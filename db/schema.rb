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

ActiveRecord::Schema.define(version: 20170325215806) do

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "country_id"
    t.integer  "sector_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "sectors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sectors_on_name", unique: true
  end

  create_table "statements", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "url"
    t.date     "date_seen"
    t.string   "approved_by_board"
    t.string   "approved_by"
    t.boolean  "signed_by_director"
    t.string   "signed_by"
    t.boolean  "link_on_front_page"
    t.string   "linked_from"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

end
