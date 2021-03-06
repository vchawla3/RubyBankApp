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

ActiveRecord::Schema.define(version: 20170221225158) do

  create_table "account_requests", force: :cascade do |t|
    t.integer  "userid"
    t.boolean  "created",    default: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id"], name: "index_account_requests_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string   "acc_number"
    t.boolean  "is_closed"
    t.decimal  "balance",    default: "0.0"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "friends", force: :cascade do |t|
    t.string   "friend1"
    t.string   "friend2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "transtype"
    t.string   "receiver"
    t.string   "status"
    t.decimal  "amount"
    t.datetime "start_date"
    t.datetime "effective_date"
    t.integer  "account_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "name"
    t.boolean  "is_admin",               default: false
    t.boolean  "is_user",                default: true
    t.boolean  "is_super",               default: false
    t.string   "current_account"
    t.string   "current_transaction"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.index ["current_account"], name: "index_users_on_current_account"
    t.index ["current_transaction"], name: "index_users_on_current_transaction"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["is_admin"], name: "index_users_on_is_admin"
    t.index ["is_super"], name: "index_users_on_is_super"
    t.index ["is_user"], name: "index_users_on_is_user"
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
