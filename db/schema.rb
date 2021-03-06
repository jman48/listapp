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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160614034643) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "list_id"
    t.integer  "order"
  end

  add_index "items", ["id"], name: "index_items_on_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  add_index "lists", ["id"], name: "index_lists_on_id", using: :btree

  create_table "lists_users", force: :cascade do |t|
    t.integer "list_id"
    t.integer "user_id"
  end

  add_index "lists_users", ["list_id", "user_id"], name: "index_lists_users_on_list_id_and_user_id", using: :btree
  add_index "lists_users", ["user_id"], name: "index_lists_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "salt"
    t.string   "email"
    t.string   "user_id"
    t.string   "picture"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["id"], name: "index_users_on_id", using: :btree
  add_index "users", ["user_id"], name: "index_users_on_user_id", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
