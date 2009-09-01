class AddInspirations < ActiveRecord::Migration
  def self.up
    create_table(:inspirations) do |t|
      t.column 'topic_id', :integer
      t.column 'inspiration_id', :integer
      t.column 'inspired_id', :integer      
      t.column 'inspiration_author', :string
      t.column 'inspired_author', :string
    end
  end

  def self.down
    drop_table(:inspirations)
  end
end
