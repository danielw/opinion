class AddForumBodyAndCategorySubtitles < ActiveRecord::Migration
  def self.up
    add_column "forums", "body", :string
    add_column "categories", "subtitle", :string
  end

  def self.down
    remove_column "forums", "body"
    remove_column "categories", "subtitle"
  end
end
