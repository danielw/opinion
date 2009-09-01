class AddUserType < ActiveRecord::Migration
  def self.up
    add_column 'users', 'type', :string
    add_column 'users', 'remote_user_id', :integer
    add_column 'users', 'remote_login_site_id', :integer
    add_column 'users', 'post_count', :integer, :default => 0

    create_table(:remote_login_sites) do |t|
      t.column 'url', :string
      t.column 'token', :string, :limit => 32
    end
    
  end

  def self.down
    
    drop_table(:remote_login_sites)
    
    remove_column 'users', 'type'
    remove_column 'users', 'remote_user_id'
    remove_column 'users', 'remote_login_site_id'
    remove_column 'users', 'post_count'
  end
end
