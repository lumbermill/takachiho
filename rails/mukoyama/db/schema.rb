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

ActiveRecord::Schema.define(version: 20170519120209) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "raspi_id",      limit: 4
    t.string   "mail",          limit: 255
    t.boolean  "active"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "snooze",        limit: 4,   default: 60, null: false
    t.boolean  "motion_sensor"
  end

  add_index "addresses", ["raspi_id", "mail"], name: "index_addresses_on_raspi_id_and_mail", unique: true, using: :btree

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type", limit: 255
    t.integer  "impressionable_id",   limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "controller_name",     limit: 255
    t.string   "action_name",         limit: 255
    t.string   "view_name",           limit: 255
    t.string   "request_hash",        limit: 255
    t.string   "ip_address",          limit: 255
    t.string   "session_hash",        limit: 255
    t.string   "message",             limit: 255
    t.string   "referrer",            limit: 255
    t.string   "params",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "mail_logs", force: :cascade do |t|
    t.integer  "address_id", limit: 4
    t.datetime "time_stamp"
    t.boolean  "delivered"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "picture_groups", force: :cascade do |t|
    t.integer  "raspi_id",   limit: 4,                 null: false
    t.boolean  "starred",              default: false, null: false
    t.integer  "head",       limit: 8,                 null: false
    t.integer  "tail",       limit: 8,                 null: false
    t.integer  "n",          limit: 4, default: 0,     null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "sakura_iot_modules", force: :cascade do |t|
    t.integer  "raspi_id",   limit: 4
    t.string   "token",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sakura_iot_modules", ["raspi_id"], name: "index_sakura_iot_modules_on_raspi_id", unique: true, using: :btree

  create_table "settings", force: :cascade do |t|
    t.integer  "raspi_id",    limit: 4
    t.float    "min_tmpr",    limit: 24
    t.float    "max_tmpr",    limit: 24
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
    t.string   "name",        limit: 255
    t.string   "token4write", limit: 255
    t.string   "token4read",  limit: 255
    t.integer  "city_id",     limit: 8
  end

  add_index "settings", ["raspi_id"], name: "index_settings_on_raspi_id", unique: true, using: :btree

  create_table "tmpr_daily_logs", force: :cascade do |t|
    t.integer  "raspi_id",            limit: 4
    t.date     "time_stamp"
    t.float    "temperature_average", limit: 24
    t.float    "pressure_average",    limit: 24
    t.float    "humidity_average",    limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.float    "temperature_max",     limit: 24
    t.float    "pressure_max",        limit: 24
    t.float    "humidity_max",        limit: 24
    t.float    "temperature_min",     limit: 24
    t.float    "pressure_min",        limit: 24
    t.float    "humidity_min",        limit: 24
  end

  add_index "tmpr_daily_logs", ["raspi_id", "time_stamp"], name: "index_tmpr_daily_logs_on_raspi_id_and_time_stamp", unique: true, using: :btree

  create_table "tmpr_logs", force: :cascade do |t|
    t.integer  "raspi_id",    limit: 4
    t.datetime "time_stamp"
    t.float    "temperature", limit: 24
    t.float    "pressure",    limit: 24
    t.float    "humidity",    limit: 24
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "sender",      limit: 255
  end

  add_index "tmpr_logs", ["raspi_id", "time_stamp"], name: "index_tmpr_logs_on_raspi_id_and_time_stamp", unique: true, using: :btree

  create_table "tmpr_monthly_logs", force: :cascade do |t|
    t.integer  "raspi_id",            limit: 4
    t.integer  "year_month",          limit: 4
    t.float    "temperature_average", limit: 24
    t.float    "pressure_average",    limit: 24
    t.float    "humidity_average",    limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.float    "temperature_max",     limit: 24
    t.float    "pressure_max",        limit: 24
    t.float    "humidity_max",        limit: 24
    t.float    "temperature_min",     limit: 24
    t.float    "pressure_min",        limit: 24
    t.float    "humidity_min",        limit: 24
  end

  add_index "tmpr_monthly_logs", ["raspi_id", "year_month"], name: "index_tmpr_monthly_logs_on_raspi_id_and_year_month", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weathers", id: false, force: :cascade do |t|
    t.datetime "dt",                                    null: false
    t.integer  "id",           limit: 8,                null: false
    t.string   "weather_main", limit: 255, default: "", null: false
    t.string   "weather_desc", limit: 255, default: "", null: false
    t.float    "temp",         limit: 24
    t.float    "pressure",     limit: 24
    t.integer  "humidity",     limit: 4
    t.float    "wind_speed",   limit: 24
    t.float    "wind_deg",     limit: 24
    t.integer  "cloudiness",   limit: 4
    t.float    "rain",         limit: 24
    t.float    "snow",         limit: 24
    t.datetime "modified_at",                           null: false
  end

  create_table "weathers_cities", force: :cascade do |t|
    t.string   "name",        limit: 255, default: "", null: false
    t.string   "name_jp",     limit: 255, default: "", null: false
    t.float    "lon",         limit: 24
    t.float    "lat",         limit: 24
    t.datetime "modified_at",                          null: false
  end

end
