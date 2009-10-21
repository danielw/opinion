require 'rubygems'
require 'active_support'
require 'tinder'

namespace :deploy do
  desc "Tell campfire about the deployment"
  task :announce do
    changes = `git log --no-color --pretty=format:' * %an: %s' --abbrev-commit --no-merges #{previous_revision}..#{real_revision}`
    statement = "#{ENV['USER']} deployed #{application} to #{rails_env.capitalize} server farm\n\n#{changes}"

    campfire = Tinder::Campfire.new('jadedpixel', :ssl => true)
    campfire.login campfire_login, campfire_password
    room = campfire.find_room_by_name(announce_in)
    room.paste(statement)
  end
end