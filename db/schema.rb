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

ActiveRecord::Schema.define(:version => 0) do

  create_table "categories", :primary_key => "category_id", :force => true do |t|
    t.string  "category_name", :limit => 50
    t.integer "parent_id",     :limit => 10
  end

  add_index "categories", ["category_id"], :name => "category_id"

  create_table "model_product_categories", :force => true do |t|
    t.integer  "model_id",     :limit => 10, :default => 0,   :null => false
    t.integer  "product_id",   :limit => 10, :default => 0,   :null => false
    t.string   "note",         :limit => 50, :default => " "
    t.integer  "category_id",  :limit => 10, :default => 0,   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :limit => 10
  end

  add_index "model_product_categories", ["product_id"], :name => "product_id"
  add_index "model_product_categories", ["model_id"], :name => "model_id"
  add_index "model_product_categories", ["category_id"], :name => "category_id"

  create_table "models", :primary_key => "model_id", :force => true do |t|
    t.string   "make",         :limit => 50, :null => false
    t.string   "model",        :limit => 50
    t.integer  "year",         :limit => 10, :null => false
    t.integer  "cc",           :limit => 10, :null => false
    t.string   "description",  :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :limit => 10
  end

  add_index "models", ["make", "model", "year", "description"], :name => "Make"

  create_table "products", :primary_key => "product_id", :force => true do |t|
    t.string "product_number", :limit => 50
    t.string "product_desc",   :limit => 150
  end

  add_index "products", ["product_id"], :name => "product_id"
  add_index "products", ["product_number"], :name => "product_number"

end
