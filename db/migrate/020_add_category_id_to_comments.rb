class AddCategoryIdToComments < ActiveRecord::Migration
  def self.up
    transaction do
      Comment.find(:all).each do |c|
        c.category_id = c.topic.category
        c.save!
      end
    end
  end

  def self.down
  end
end
