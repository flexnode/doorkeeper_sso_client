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

ActiveRecord::Schema.define(version: 20150514064926) do

  create_table "sso_client_passports", force: :cascade do |t|
    t.integer  "identity_id"
    t.string   "identity_type"
    t.string   "secret"
    t.string   "state"
    t.string   "chip"
    t.string   "user"
    t.boolean  "verified",      default: false
    t.boolean  "modified",      default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "expiry"
  end

  add_index "sso_client_passports", ["identity_type", "identity_id"], name: "index_sso_client_passports_on_identity_type_and_identity_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                     null: false
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "lang",       default: "EN"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
