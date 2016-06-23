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

ActiveRecord::Schema.define(version: 20160623121608) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inboxes", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "key",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "inboxes", ["key"], name: "index_inboxes_on_key", unique: true, using: :btree

  create_table "team_inboxes", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "inbox_id"
    t.integer  "order",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "team_inboxes", ["inbox_id"], name: "index_team_inboxes_on_inbox_id", using: :btree
  add_index "team_inboxes", ["team_id"], name: "index_team_inboxes_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "key",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teams", ["key"], name: "index_teams_on_key", unique: true, using: :btree

  add_foreign_key "team_inboxes", "inboxes"
  add_foreign_key "team_inboxes", "teams"
end
