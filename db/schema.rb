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

ActiveRecord::Schema.define(version: 20170718153034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "country_id"
    t.integer  "sector_id"
    t.index ["country_id"], name: "index_companies_on_country_id", using: :btree
    t.index ["sector_id"], name: "index_companies_on_sector_id", using: :btree
  end

  create_table "countries", force: :cascade do |t|
    t.string   "code",       null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "lat"
    t.float    "lng"
    t.index ["code"], name: "index_countries_on_code", unique: true, using: :btree
    t.index ["name"], name: "index_countries_on_name", unique: true, using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.string  "title",       null: false
    t.string  "short_title", null: false
    t.string  "slug",        null: false
    t.text    "body_html",   null: false
    t.integer "position",    null: false
    t.boolean "published"
    t.index ["slug"], name: "index_pages_on_slug", unique: true, using: :btree
  end

  create_table "sectors", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sectors_on_name", unique: true, using: :btree
  end

  create_table "snapshots", force: :cascade do |t|
    t.binary  "content_data",       null: false
    t.string  "content_type",       null: false
    t.integer "statement_id"
    t.string  "image_content_type"
    t.binary  "image_content_data"
    t.index ["statement_id"], name: "index_snapshots_on_statement_id", using: :btree
  end

  create_table "statements", force: :cascade do |t|
    t.integer  "company_id",                            null: false
    t.string   "url",                                   null: false
    t.date     "date_seen",                             null: false
    t.string   "approved_by_board"
    t.string   "approved_by"
    t.boolean  "signed_by_director"
    t.string   "signed_by"
    t.boolean  "link_on_front_page"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "broken_url"
    t.integer  "verified_by_id"
    t.boolean  "published",             default: false
    t.string   "contributor_email"
    t.boolean  "latest",                default: false
    t.boolean  "latest_published",      default: false
    t.boolean  "marked_not_broken_url", default: false
    t.index ["company_id"], name: "index_statements_on_company_id", using: :btree
    t.index ["latest"], name: "index_statements_on_latest", where: "latest", using: :btree
    t.index ["latest_published"], name: "index_statements_on_latest_published", where: "latest_published", using: :btree
    t.index ["published"], name: "index_statements_on_published", using: :btree
    t.index ["verified_by_id"], name: "index_statements_on_verified_by_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "admin"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "companies", "countries"
  add_foreign_key "snapshots", "statements"
  add_foreign_key "statements", "companies"
  add_foreign_key "statements", "users", column: "verified_by_id"
end
