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

ActiveRecord::Schema.define(:version => 20130208153242) do

  create_table "custom_configs", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "custom_configs", ["name"], :name => "index_custom_configs_on_name", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "which_chat"
    t.text     "body"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "pairings", :force => true do |t|
    t.datetime "formed"
    t.datetime "chat_start"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "participants", :force => true do |t|
    t.string   "code"
    t.integer  "pairing_id"
    t.integer  "pairing_role"
    t.integer  "quiz_score"
    t.float    "money_transfer"
    t.datetime "joined"
    t.datetime "last_contact"
    t.string   "status_data"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
