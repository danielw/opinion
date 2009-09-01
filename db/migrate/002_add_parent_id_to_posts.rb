class AddParentIdToPosts < ActiveRecord::Migration
  def self.up
    add_column 'posts', 'parent_id', :integer
  end

  def self.down
    remove_column 'posts', 'parent_id'
  end
end
