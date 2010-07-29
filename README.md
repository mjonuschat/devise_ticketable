# devise_ticketable

Adds support to [devise](http://github.com/plataformatec/devise) for acting as a single sign on server
using [mod\_auth\_tkt](http://www.openfusion.com.au/labs/mod_auth_tkt/) for the [Apache HTTP Server](http://httpd.apache.org/)

## Installation

Rails 2.3 - add the following to your list of gems

    config.gem 'devise_ticketable'

Rails 3 - add the following to your Gemfile

    gem 'devise_ticketable'

## Configuration

devise_ticketable add a few configuration options to devise.

1. The secret used to generate cookies. Set to empty string by default. Should be set to some long and random
string comparable to the Rails cookie secret. This value needs to mach your webserver configuration!

    config.auth\_tkt\_domain = secret


1. The domain for which the cookie is valid. Not set by default. Setting this to something like '.example.com'
allows single sign on across multiple subdomains

    config.auth\_tkt\_domain = ''

1. Optionally do a Base64 encode of the cookie data. Not enabled by default.

    config.auth\_tkt\_encode = false

1. Ignore the remote ip address when generating or validating the ticket. Not enabled by default.

    config.auth\_tkt\_ignore\_ip = false

## Accessors / Model attributes

devise_ticketable makes use of a few optional but recommended accessors on your user model.

1. :auth\_tkt\_user

    Define this so that it returns the username you might later use to grant access

1. :auth\_tkt\_user\_data

    Can be used to return payload data that mod\_auth\_tkt may use

1. :auth\_tkt\_token\_list

    Should return a list of comma separated tokens can be used for authentication purposes by mod\_auth\_tkt.
    Possible uses include returning group memberships or roles.

## Limitations

Currently the cookie name is hardcoded to *auth_tkt*. As there is no documentation available for mod\_auth\_tkt that suggests
that the cookie name is configurable this doesn't pose any serious problems.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Morton Jonuschat. See LICENSE for details.
