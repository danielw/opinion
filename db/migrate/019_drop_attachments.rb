class DropAttachments < ActiveRecord::Migration
  def self.up
    drop_table('attachments')
  end

  def self.down
    create_table(:attachments) do |t|
      t.column 'image', :string
      t.column 'topic_id', :integer
    end
  end
end
