# Before the user gets logged out we destroy the mod_auth_tkt cookie
#
# This is only triggered when the user is explicitly set (with set_user)
# and on authentication. Retrieving the user from session (:fetch) does
# not trigger it.

Warden::Manager.before_logout do |record, warden, opts|
  if record.respond_to?(:destroy_auth_tkt_cookie!)
    cookie_data = record.destroy_auth_tkt_cookie!
    warden.cookies[:auth_tkt] = cookie_data
    warden.cookies.delete(:auth_tkt)
  end
end

# After the user gets logged in we set the mod_auth_tkt cookie
#
# This callback is triggered the first time one of those three
# events happens during a request: :authentication, :fetch
# (from session) and :set_user (when manually set)

Warden::Manager.after_authentication do |record, warden, opts|
  if record.respond_to?(:get_auth_tkt_cookie!)
    options = {}
    options[:user]        = record.auth_tkt_user        if record.respond_to?(:auth_tkt_user)
    options[:user_data]   = record.auth_tkt_user_data   if record.respond_to?(:auth_tkt_user_data)
    options[:token_list]  = record.auth_tkt_token_list  if record.respond_to?(:auth_tkt_token_list)

    warden.cookies[:auth_tkt] = record.get_auth_tkt_cookie!(options, warden.request)
  end
end
