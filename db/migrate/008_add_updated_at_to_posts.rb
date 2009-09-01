class AddUpdatedAtToPosts < ActiveRecord::Migration
  def self.up
    add_column 'posts', 'updated_at', :datetime
  end

  def self.down
    remove_column 'posts', 'updated_at'
  end
end
