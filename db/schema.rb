# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121009131350) do

  create_table "events", :force => true do |t|
    t.string   "province",           :default => ""
    t.string   "region",             :default => ""
    t.string   "city",               :default => ""
    t.string   "main_category",      :default => ""
    t.string   "sub_category",       :default => ""
    t.string   "venue",              :default => ""
    t.date     "start_date",         :default => '2012-10-02'
    t.date     "end_date",           :default => '2012-10-02'
    t.time     "start_date_time",    :default => '2000-01-01 15:41:23'
    t.time     "end_date_time",      :default => '2000-01-01 15:41:23'
    t.string   "title",              :default => ""
    t.string   "venue_url",          :default => ""
    t.string   "email",              :default => ""
    t.string   "tel_nr",             :default => ""
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "description",        :default => ""
    t.string   "address",            :default => ""
    t.string   "costs",              :default => ""
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "repeat_dates"
    t.boolean  "sponsored"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "federal_highlight"
    t.boolean  "regional_highlight"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
