# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 33) do

  create_table "categories", :force => true do |t|
    t.string  "title"
    t.integer "forum_id"
    t.text    "body",         :limit => 255
    t.text    "body_html",    :limit => 255
    t.string  "subtitle"
    t.integer "access_level",                :default => 0
  end

  add_index "categories", ["forum_id"], :name => "index_categories_on_area_id_and_title_dashed"

  create_table "forums", :force => true do |t|
    t.string  "title"
    t.boolean "anonymous_posts",                :default => false
    t.text    "body",            :limit => 255
  end

  create_table "images", :force => true do |t|
    t.integer "parent_id"
    t.integer "post_id"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
  end

  add_index "images", ["parent_id"], :name => "index_images_on_parent_id"
  add_index "images", ["post_id"], :name => "index_images_on_post_id"

  create_table "posts", :force => true do |t|
    t.integer  "category_id"
    t.string   "title"
    t.text     "body"
    t.text     "body_html"
    t.integer  "user_id"
    t.datetime "created_at"
    t.string   "type"
    t.integer  "parent_id"
    t.integer  "forum_id"
    t.datetime "updated_at"
    t.string   "status",      :default => "normal"
    t.datetime "edited_at"
  end

  create_table "users", :force => true do |t|
    t.string  "password"
    t.string  "name"
    t.string  "email"
    t.string  "url"
    t.integer "level"
    t.string  "token",     :limit => 32
    t.string  "title"
    t.text    "signature", :limit => 255
  end

end
