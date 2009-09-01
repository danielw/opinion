class AddIndex < ActiveRecord::Migration
  def self.up
    add_index 'areas', 'title_dashed'
    add_index 'categories', ['area_id','title_dashed']
  end

  def self.down
    remove_index 'areas', 'title_dashed'
    remove_index 'categories', 'area_id'
  end
end
