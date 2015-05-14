ActiveRecord::Schema.define do

  create_table "users", force: :cascade do |t|
    t.string   "email",    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "lang",                   default: "EN"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
end
