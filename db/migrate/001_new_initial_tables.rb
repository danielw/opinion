class NewInitialTables < ActiveRecord::Migration
  def self.up
    create_table(:posts) do |t|
      t.column 'category_id', :integer
      t.column 'title', :string
      t.column 'body', :text
      t.column 'body_html', :text
      t.column 'user_id', :integer 
      t.column 'created_at', :datetime
      t.column 'type', :string
    end
    
    create_table(:users) do |t|
      t.column 'login', :string
      t.column 'password', :string
      t.column 'name', :string
      t.column 'email', :string
      t.column 'url', :string
      t.column 'gravatar_url', :string
    end
      
    create_table(:categories) do |t|
      t.column 'title', :string
    end
  end

  def self.down
    drop_table(:posts)
    drop_table(:users)
    drop_table(:categories)
  end
end
