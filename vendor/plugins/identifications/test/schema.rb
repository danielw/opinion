ActiveRecord::Schema.define(:version => 1) do

  create_table :posts, :force => true do |t|
    t.column :title, :string
    t.column :handle, :string
    t.column :shop_id, :integer
  end

  create_table :strange_articles, :force => true do |t|
    t.column :name, :string
    t.column :handle, :string
  end

  create_table :articles, :force => true do |t|
    t.column :title, :string
    t.column :token, :string
  end

  create_table :secret_articles, :force => true do |t|
    t.column :title, :string
    t.column :token, :string, :limit => 10
  end
    
end