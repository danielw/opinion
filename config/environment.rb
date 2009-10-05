# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use
  config.frameworks -= [ :action_web_service, :active_resource ]

  # Add additional load paths for your own custom dirs
  config.gem "RedCloth",              :version => '= 4.2.0'
  config.gem 'mislav-will_paginate',  :version => '>= 2.3.11', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'ultrasphinx', :version => '>= 1.11.0'

  # config.controller_paths += %W( #{RAILS_ROOT}/vendor/plugins/routing_navigator/lib )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake create_sessions_table')
  # config.action_controller.session_store = :active_record_store

  # Enable page/fragment caching by setting a file-based store
  # (remember to create the caching directory and make it readable to the application)
  # config.action_controller.fragment_cache_store = :file_store, "#{RAILS_ROOT}/cache"

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  config.time_zone = 'UTC'
  
  config.after_initialize do
    SphinxModels = [Post]
    
    HtmlEngine.default = [:whitelist_html, :autolink, :sanitize]
    # Opinion supports the www.recaptcha.com captcha service. Sign up and provide a
    # config/recaptcha.yml file with your private and public key information.
    if File.exists?(Rails.root + "config/recaptcha.yml")
      settings = YAML.load_file(Rails.root + "config/recaptcha.yml")[RAILS_ENV]
      ReCaptcha.public_key, ReCaptcha.private_key = settings['public_key'], settings['private_key']
    end
  end
end

require 'dash_string'