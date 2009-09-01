class Cleanup < ActiveRecord::Migration
  def self.up
    drop_table(:inspirations)

    remove_column "users", "area_id"
    remove_column "users", "type"
    remove_column "users", "remote_user_id"
    remove_column "users", "remote_login_site_id"

  end

  def self.down
    add_column "users", "area_id", :integer
    add_column "users", "type", :string
    add_column "users", "remote_user_id", :integer
    add_column "users", "remote_login_site_id", :integer
    
    create_table "inspirations" do |t|
      t.column "topic_id",           :integer
      t.column "inspiration_id",     :integer
      t.column "inspired_id",        :integer
      t.column "inspiration_author", :string
      t.column "inspired_author",    :string
    end
  end
end
