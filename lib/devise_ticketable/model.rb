require 'devise_ticketable/hooks/ticketable'

module Devise
  module Models
    # This module generates cookie tickets compatible
    # with the "mod_auth_tkt" apache module.
    #
    # Based on work by: MESO Web Scapes, Sascha Hanssen
    # www.meso.net/auth_tkt_rails | hanssen@meso.net

    module Ticketable
      extend ActiveSupport::Concern

      # destroys the auth_tkt cookie to sign out the current user
      def destroy_auth_tkt_cookie!
        # reset ticket value of cookie, safeguard if deleting the cookie fails
        {:value => '', :expire => Time.at(0), :domain => self.class.auth_tkt_domain}
      end

      # sets the auth_tkt cookie, returns the signed cookie string
      def get_auth_tkt_cookie!(options, request)
        # get signed cookie string
        tkt_hash = get_tkt_hash(options, request)

        cookie_data = {:value => tkt_hash}

        # set domain for cookie, if wanted
        cookie_data[:domain] = self.class.auth_tkt_domain if self.class.auth_tkt_domain

        # return signed cookie
        cookie_data
      end

      protected

        # returns a string that contains the signed cookie content
        def get_tkt_hash(user_options, request)
          options = {
            :user       => '',
            :token_list => '',
            :user_data  => '',
            :encode     => self.class.auth_tkt_encode,
            :ignore_ip  => self.class.auth_tkt_ignore_ip
          }.merge(user_options)

          # set timestamp and binary string for timestamp and ip packed together
          timestamp  = Time.now.to_i
          ip_address = options[:ignore_ip] ? '0.0.0.0' : request.remote_ip
          ip_timestamp = [ip2long(ip_address), timestamp].pack("NN")

          # creating the cookie signature
          digest0 = Digest::MD5.hexdigest(ip_timestamp + get_secret_key + options[:user] + "\0" + options[:token_list] + "\0" + options[:user_data])
          digest  = Digest::MD5.hexdigest(digest0 + get_secret_key)

          # concatenating signature, timestamp and payload
          cookie = digest + timestamp.to_s(16) + options[:user] + '!' +
                           options[:token_list] + '!' + options[:user_data]

          # base64 encode cookie, if needed
          if options[:encode]
            require 'base64'
            cookie = Base64.encode64(cookie).gsub("\n", '').strip
          end

          return cookie
        end

        # returns token list previously saved in auth_tkt cookie
        def get_auth_tkt_token_list
          cookie_decoded = Base64.decode64(cookies[:auth_tkt])
          return cookie_decoded.split('!')[1]
        end

        # returns user data previously saved in auth_tkt cookie
        def get_auth_tkt_user_data
          cookie_decoded = Base64.decode64(cookies[:auth_tkt])
          return cookie_decoded.split('!')[2]
        end

        # returns the shared secret string used to sign the cookie
        def get_secret_key
          self.class.auth_tkt_secret
        end

        # function adapted according to php: generates an IPv4 Internet network address
        # from its Internet standard format (dotted string) representation.
        def ip2long(ip)
          long = 0
          ip.split(/\./).reverse.each_with_index do |x, i|
            long += x.to_i << (i * 8)
          end
          long
        end

        # Digests the password using the configured encryptor.
        module ClassMethods
          Devise::Models.config(self, :auth_tkt_domain, :auth_tkt_encode, :auth_tkt_ignore_ip, :auth_tkt_secret)
        end
    end
  end
end
