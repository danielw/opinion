# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_opinion_session',
  :secret      => '9095544037fa27bed1cfc6919342f67da380dfc6f6c1217eb258e3b6afbfe1bcdadf2becf482769b41247db550106637c9e7a8727fca1766c210f3fd454dc1e7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store