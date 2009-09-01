class AddEditedAtToPosts < ActiveRecord::Migration
  def self.up
    add_column "posts", "edited_at", :datetime
  end

  def self.down
    remove_column "posts", "edited_at"
  end
end
