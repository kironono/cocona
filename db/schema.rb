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

ActiveRecord::Schema.define(version: 20161223021911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channel_services", force: :cascade do |t|
    t.integer  "channel_id", null: false
    t.string   "service_id", null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "channel",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "main_categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_main_categories_on_name", unique: true, using: :btree
  end

  create_table "program_has_sub_categories", force: :cascade do |t|
    t.integer  "program_id",      null: false
    t.integer  "sub_category_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["program_id"], name: "index_program_has_sub_categories_on_program_id", using: :btree
    t.index ["sub_category_id"], name: "index_program_has_sub_categories_on_sub_category_id", using: :btree
  end

  create_table "programs", force: :cascade do |t|
    t.integer  "channel_id",         null: false
    t.integer  "channel_service_id", null: false
    t.string   "event_id",           null: false
    t.string   "title",              null: false
    t.string   "detail"
    t.text     "ext_detail"
    t.datetime "start_at",           null: false
    t.integer  "duration",           null: false
    t.string   "large_category"
    t.string   "middle_category"
    t.text     "video"
    t.text     "audio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "end_at",             null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "program_id",                          null: false
    t.string   "reserve_method", default: "auto",     null: false
    t.string   "status",         default: "reserved", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reserve_rules", force: :cascade do |t|
    t.text     "condition",                             null: false
    t.string   "status",           default: "inactive", null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "last_reserved_at"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string   "name",             null: false
    t.integer  "main_category_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["main_category_id"], name: "index_sub_categories_on_main_category_id", using: :btree
    t.index ["name", "main_category_id"], name: "index_sub_categories_on_name_and_main_category_id", unique: true, using: :btree
    t.index ["name"], name: "index_sub_categories_on_name", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",               default: "", null: false
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.string   "locale",             default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "video_has_sub_categories", force: :cascade do |t|
    t.integer  "video_id",        null: false
    t.integer  "sub_category_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["sub_category_id"], name: "index_video_has_sub_categories_on_sub_category_id", using: :btree
    t.index ["video_id"], name: "index_video_has_sub_categories_on_video_id", using: :btree
  end

  create_table "videos", force: :cascade do |t|
    t.string   "channel",      null: false
    t.string   "service_id",   null: false
    t.string   "service_name", null: false
    t.string   "event_id",     null: false
    t.string   "title",        null: false
    t.string   "detail"
    t.text     "ext_detail"
    t.datetime "start_at",     null: false
    t.datetime "end_at",       null: false
    t.integer  "duration",     null: false
    t.text     "video"
    t.text     "audio"
    t.string   "store_path",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
