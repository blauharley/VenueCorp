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

ActiveRecord::Schema.define(:version => 20120924143600) do

  create_table "events", :force => true do |t|
    t.string   "province"
    t.string   "region"
    t.string   "city"
    t.string   "main_category"
    t.string   "sub_category"
    t.boolean  "highlight"
    t.string   "venue"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_date_time"
    t.time     "end_date_time"
    t.string   "photo_url"
    t.string   "title"
    t.string   "venue_url"
    t.string   "email"
    t.string   "tel_nr"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "description"
    t.string   "address"
    t.string   "costs"
  end

end
