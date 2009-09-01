if File.exist?(file = File.join('.', 'public', 'javascripts', 'application.js'))
  print "\n\nAppending lib/zoned.js to public/javascripts/application.js..."
  File.open(file, 'a') do |f|
    f << File.read(File.join('.', 'vendor', 'plugins', 'zoned', 'lib', 'zoned.js'))
  end
  puts "done."
else
  puts "Please copy over the javascript (or some modification thereof) in lib/zoned.js into the proper javascript file"
end
