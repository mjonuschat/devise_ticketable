Devise.add_module :ticketable, :model => 'devise_ticketable/model'

module Devise
  # Custom domain for auth_tkt_cookies. Not set by default
  mattr_accessor :auth_tkt_domain
  @@auth_tkt_domain = false

  # Base64 encode the cookie data. Not set by default
  mattr_accessor :auth_tkt_encode
  @@auth_tkt_encode = false

  # Do not check the remote ip address. Not set by default
  mattr_accessor :auth_tkt_ignore_ip
  @@auth_tkt_ignore_ip = false

  # Define the secret used to generate cookies. Not set by default
  mattr_accessor :auth_tkt_secret
  @@auth_tkt_secret = ''
end

#module DeviseTicketable
#end
