class AddArea < ActiveRecord::Migration
  def self.up
    
    create_table(:areas) do |t|
      t.column 'title', :string
      t.column 'title_dashed', :string
    end
    
    add_column 'users', 'level', :integer
    add_column 'users', 'area_id', :integer
    add_column 'categories', 'area_id', :integer
    add_column 'posts', 'area_id', :integer
  end

  def self.down
    
    drop_table(:areas)
    
    remove_column 'users', 'level'
    remove_column 'users', 'area_id'
    remove_column 'categories', 'area_id'
    remove_column 'posts', 'area_id'
  end
end
