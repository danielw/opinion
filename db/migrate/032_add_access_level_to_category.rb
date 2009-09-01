class AddAccessLevelToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :access_level, :integer, :null => :false, :default => 0
  end

  def self.down
    remove_column :categories, :access_level
  end
end
