class RemoveTitleDashed < ActiveRecord::Migration
  def self.up
    remove_column "forums", "title_dashed"
    remove_column "categories", "title_dashed"

  end

  def self.down

    add_column "forums", "title_dashed", :string
    add_column "categories", "title_dashed", :string
  end
end
