# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 6) do

  create_table "authors", :force => true do |t|
    t.string "name"
  end

  create_table "book_datas", :force => true do |t|
    t.integer  "pages"
    t.datetime "published_at"
    t.string   "binding"
  end

  create_table "books", :force => true do |t|
    t.string "ean"
    t.string "title"
    t.text   "description"
  end

  create_table "creators", :force => true do |t|
    t.string "name"
    t.string "role"
  end

  create_table "creatorships", :force => true do |t|
    t.integer "creator_id"
    t.integer "product_id"
  end

  create_table "products", :force => true do |t|
    t.string  "title"
    t.string  "product_code"
    t.string  "data_type"
    t.integer "data_id"
    t.string  "amazon_asin"
    t.string  "amazon_detail_page_url"
    t.string  "amazon_small_image_url"
    t.string  "amazon_medium_image_url"
    t.string  "amazon_large_image_url"
  end

end
