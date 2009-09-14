namespace :cron do
  
  task :daily do 
    Rake::Task['ultrasphinx:index'].invoke
  end
  
  task :hourly do 
    Rake::Task['ultrasphinx:index:delta'].invoke
  end
  
end