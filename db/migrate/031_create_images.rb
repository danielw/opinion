class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column :parent_id, :integer
      t.column :post_id, :integer
      t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer    
    end
    
    add_index :images, :post_id
    add_index :images, :parent_id
  end

  def self.down
    drop_table :images
  end
end
