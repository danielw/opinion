require 'rubygems'
require 'active_support'
require File.dirname(__FILE__) + '/lib/marshmallow'

namespace :deploy do
  desc "Tell campfire about the deployment"
  task :announce do
    changes = `git log --no-color --pretty=format:' * %an: %s' --abbrev-commit --no-merges #{previous_revision}..#{real_revision}`

    statement = "#{ENV['USER']} deployed #{application} to #{rails_env.capitalize} server farm\n\n#{changes}"
               
    Marshmallow.connect(announce_in) do |bot|
      bot.paste(statement)    
    end
  end
end