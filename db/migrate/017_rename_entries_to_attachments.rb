class RenameEntriesToAttachments < ActiveRecord::Migration
  def self.up
    rename_table 'entries', 'attachments'
  end

  def self.down
    rename_table 'attachments', 'entries'
  end
end
