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

ActiveRecord::Schema.define(:version => 20100720105101) do

  create_table "measure_datas", :force => true do |t|
    t.integer  "user_id"
    t.string   "ruby_type"
    t.text     "datas"
    t.datetime "measured_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "measure_datas", ["ruby_type"], :name => "index_measure_datas_on_ruby_type"
  add_index "measure_datas", ["user_id", "ruby_type"], :name => "index_measure_datas_on_user_id_and_ruby_type"
  add_index "measure_datas", ["user_id"], :name => "index_measure_datas_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "api_key",                   :limit => 40,  :default => ""
    t.string   "type"
  end

  add_index "users", ["api_key"], :name => "index_users_on_api_key"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
