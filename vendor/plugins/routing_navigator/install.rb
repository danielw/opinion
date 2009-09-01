FileUtils.cp File.join(File.dirname(__FILE__), 'public/javascripts/routing_navigator.js'),  File.join(File.dirname(__FILE__), '../../../public/javascripts')
FileUtils.cp File.join(File.dirname(__FILE__), 'public/stylesheets/routing_navigator.css'), File.join(File.dirname(__FILE__), '../../../public/stylesheets')
puts IO.read(File.join(File.dirname(__FILE__), 'README'))