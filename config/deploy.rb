Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

set :application, "opinion"
set :repository,  "git@github.com:Shopify/opinion.git"
set :branch,      "origin/master"
set :scm,         :git
set :deploy_via,  :fast_remote_cache
set :announce_in, "https://bot@jadedpixel.com:hallo28@jadedpixel.campfirenow.com/room/100257"

role :app, "forums.cloud.shopify.com"
role :web, "forums.cloud.shopify.com"
role :db,  "forums.cloud.shopify.com", :primary => true

desc "Signal Passenger to restart the application"
task :restart, :roles => :app do
  run "touch #{release_path}/tmp/restart.txt"
end

after "deploy:update_code", "deploy::migrate"