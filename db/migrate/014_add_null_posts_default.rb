class AddNullPostsDefault < ActiveRecord::Migration
  def self.up
    change_column 'users', 'post_count', :integer, :null => false, :default => 0
  end

  def self.down
  end
end
