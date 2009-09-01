class AddAnonPostsForAreas < ActiveRecord::Migration
  def self.up
    add_column 'areas', 'anonymous_posts', :boolean, :default => false
  end

  def self.down
    remove_column 'areas', 'anonymous_posts', :boolean
  end
end
