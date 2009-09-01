class AreasToForums < ActiveRecord::Migration
  def self.up
    rename_table 'areas', 'forums'
    rename_column 'categories', 'area_id', 'forum_id'
    rename_column 'posts', 'area_id', 'forum_id'
    drop_table 'remote_login_sites'
  end

  def self.down
    rename_table 'forums', 'areas'
    rename_column 'categories', 'forum_id', 'area_id'
    rename_column 'posts', 'forum_id', 'area_id'

    create_table "remote_login_sites" do |t|
      t.column "url",     :string
      t.column "token",   :string,  :limit => 32
      t.column "area_id", :integer
    end
  end
end
