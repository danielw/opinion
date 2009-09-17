# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'stringio'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use
  config.frameworks -= [ :action_web_service ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/vendor/RedCloth-3.0.3/lib  )
  
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

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  
  config.action_controller.session = { 
    :session_key => '_opinion_session', 
    :secret      => '<%= CGI::Session.generate_unique_id("opinion") %>' 
  }  
  
  # Use Active Record's schema dumper instead of SQL when creating the test database
  # (enables use of different database adapters for development and test environments)
  config.active_record.schema_format = :ruby

  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

HtmlEngine.default = [:textile, :whitelist_html, :autolink, :sanitize]

# Include your application configuration below
require 'dash_string'
Dir[RAILS_ROOT + '/lib/extensions/*.rb'].each { |file| require file }

# Opinion supports the www.recaptcha.com captcha service. Sign up and provide a
# config/recaptcha.yml file with your private and public key information.
if File.exists?(RAILS_ROOT + "/config/recaptcha.yml")
  settings = YAML.load_file(RAILS_ROOT + "/config/recaptcha.yml")[RAILS_ENV]
  ReCaptcha.public_key, ReCaptcha.private_key = settings['public_key'], settings['private_key']
end