class RemovePostCount < ActiveRecord::Migration
  def self.up
    remove_column "users", "post_count"
  end

  def self.down
    add_column "users", "post_count", :integer
  end
end
