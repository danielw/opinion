desc "Copies the latest routing navigator assets to the application's public directory"
task :update_routing_navigator do
  FileUtils.cp File.join(File.dirname(__FILE__), '../public/javascripts/routing_navigator.js'),  File.join(RAILS_ROOT, 'public', 'javascripts')
  FileUtils.cp File.join(File.dirname(__FILE__), '../public/stylesheets/routing_navigator.css'), File.join(RAILS_ROOT, 'public', 'stylesheets')
end