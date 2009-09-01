class AddTitleDashedToCategories < ActiveRecord::Migration
  def self.up
    add_column 'categories', 'title_dashed', :string
  end

  def self.down
    remove_column 'categories', 'title_dashed'
  end
end
