class AddAreaIdToRemoteSites < ActiveRecord::Migration
  def self.up
    add_column 'remote_login_sites', 'area_id', :integer
  end

  def self.down
    remove_column 'remote_login_sites', 'area_id'
  end
end
