set :application, "opinion"
set :repository,  "git@github.com:Shopify/opinion.git"
set :scm,         :git
set :deploy_via,  :fast_remote_cache
set :campfire_login, "bot@jadedpixel.com"
set :campfire_password, "hallo28"
set :announce_in, "Open Bar 1.1"
set :user,        "deploy"
set :rails_env,   "production"
set :branch,      "master"

role :app, "forums.cloud.shopify.com"
role :web, "forums.cloud.shopify.com"
role :db,  "forums.cloud.shopify.com", :primary => true

namespace :gems do     
  task :install, :roles => :app do
    run "cd #{release_path} && sudo rake RAILS_ENV=#{rails_env} gems:install"
  end
end

namespace :deploy do
  
  task :link_configs do
    run "ln -nfs #{shared_path}/tmp/attachment_fu #{release_path}/tmp/attachment_fu"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/files #{release_path}/public/files"
  end

  desc "Signal Passenger to restart the application"
  task :restart, :roles => :app do
    run "touch #{release_path}/tmp/restart.txt"
  end
end

namespace :ultrasphinx do
    
  task :index do
    run "cd #{current_path} && rake RAILS_ENV=#{rails_env} ultrasphinx:index"
  end
    
  [:bootstrap, :configure].each do |t|
    task t do
      run "cd #{release_path} && rake RAILS_ENV=#{rails_env} ultrasphinx:#{t}"
    end
  end
    
  namespace :daemon do
    [:restart, :start, :status, :stop].each do |t|
      task t do
        sudo "sv #{t} opinion-searchd"
      end
    end    
  end
    
  namespace :spelling do
    task :build do
      run "cd #{current_path} && rake RAILS_ENV=#{rails_env} ultrasphinx:spelling:build"
    end
  end

end

after "deploy:update_code", "deploy:link_configs", "gems:install", "deploy:migrate", "ultrasphinx:configure"
after 'deploy', 'deploy:cleanup', 'deploy:announce'