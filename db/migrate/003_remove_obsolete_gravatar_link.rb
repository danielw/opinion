class RemoveObsoleteGravatarLink < ActiveRecord::Migration
  def self.up
    remove_column 'users', 'gravatar_url'
  end

  def self.down
    add_column 'users', 'gravatar_url', :string
  end
end
