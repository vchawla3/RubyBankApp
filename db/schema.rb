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

ActiveRecord::Schema.define(version: 20170211225251) do

  create_table "accounts", force: :cascade do |t|
    t.string   "acc_number"
    t.boolean  "is_closed"
    t.decimal  "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friends", force: :cascade do |t|
    t.string   "friend1"
    t.string   "friend2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "LName"
    t.string   "FName"
    t.string   "init"
    t.string   "email"
    t.string   "password"
    t.string   "salt"
    t.boolean  "is_admin"
    t.boolean  "is_user"
    t.boolean  "is_super"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.text     "instructions"
    t.integer  "category_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["category_id"], name: "index_recipes_on_category_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "type"
    t.text     "sender"
    t.text     "receiver"
    t.string   "status"
    t.decimal  "amount"
    t.datetime "start_date"
    t.datetime "effective_date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
