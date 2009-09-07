class AddSaneIndexes < ActiveRecord::Migration
  def self.up
    add_index :users, :email
    
    add_index :categories, :access_level
    
    add_index :posts, [:parent_id, :type]
    add_index :posts, :created_at
    add_index :posts, [:category_id, :type]
  end

  def self.down
    remove_index :posts, [:parent_id, :type]
    remove_index :posts, :created_at
    remove_index :categories, :access_level
    remove_index :users, :email
    remove_index :posts, [:category_id, :type]
  end
end
