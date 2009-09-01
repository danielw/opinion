class AddEntriesForFiles < ActiveRecord::Migration

  def self.up
    create_table(:entries) do |t|
      t.column 'image', :string
      t.column 'post_id', :integer
    end
  end

  def self.down
    drop_table(:entries)
  end
end
