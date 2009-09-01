class ChangeCategoryDescriptionFromStringToText < ActiveRecord::Migration
  def self.up
    change_column 'categories', 'body', :text
    change_column 'categories', 'body_html', :text
    change_column 'forums', 'body', :text
  end

  def self.down
    change_column 'categories', 'body', :string
    change_column 'categories', 'body_html', :string
    change_column 'forums', 'body', :string
  end
end
