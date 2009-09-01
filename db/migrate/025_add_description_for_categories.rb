class AddDescriptionForCategories < ActiveRecord::Migration
  def self.up
    add_column "categories", "body", :string
    add_column "categories", "body_html", :string
  end

  def self.down
    remove_column "categories", "body"
    remove_column "categories", "body_html"
  end
end
