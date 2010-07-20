# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_monitor_platform_session',
  :secret      => '6891bd23a077e425e9f221e8f9ff46d672785b17c717509e0bd26d214686893ee5535a8fa988ed97a87cab5a65a265ec3085e7f0158a779721aac8bc1d58dfd7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
