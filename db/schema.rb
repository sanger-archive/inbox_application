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

ActiveRecord::Schema.define(version: 20160706082700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "batches", force: :cascade do |t|
    t.uuid     "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_batches_on_user_id", using: :btree
  end

  create_table "checkpoints", force: :cascade do |t|
    t.integer  "inbox_id",     null: false
    t.string   "direction",    null: false
    t.string   "subject_role", null: false
    t.string   "event_type",   null: false
    t.text     "conditions",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["inbox_id"], name: "index_checkpoints_on_inbox_id", using: :btree
  end

  create_table "inboxes", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "key",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_inboxes_on_key", unique: true, using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.uuid     "uuid",         null: false
    t.string   "name",         null: false
    t.text     "details"
    t.integer  "inbox_id",     null: false
    t.integer  "batch_id"
    t.datetime "completed_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "team_inboxes", force: :cascade do |t|
    t.integer  "team_id",    null: false
    t.integer  "inbox_id",   null: false
    t.integer  "order",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inbox_id"], name: "index_team_inboxes_on_inbox_id", using: :btree
    t.index ["team_id"], name: "index_team_inboxes_on_team_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "key",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_teams_on_key", unique: true, using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v1()" }, force: :cascade do |t|
    t.string   "login",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_users_on_login", unique: true, using: :btree
  end

  add_foreign_key "batches", "users"
  add_foreign_key "checkpoints", "inboxes"
  add_foreign_key "team_inboxes", "inboxes"
  add_foreign_key "team_inboxes", "teams"
end
