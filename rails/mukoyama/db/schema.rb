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

ActiveRecord::Schema.define(version: 20170617231400) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "device_id",  limit: 4
    t.string   "type",       limit: 255, default: "",   null: false
    t.string   "address",    limit: 255, default: "",   null: false
    t.integer  "snooze",     limit: 4,   default: 60,   null: false
    t.boolean  "active",                 default: true, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "addresses", ["device_id", "address"], name: "index_addresses_on_device_id_and_address", unique: true, using: :btree

  create_table "devices", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.integer  "city_id",        limit: 8
    t.string   "type",           limit: 255,      default: "", null: false
    t.string   "name",           limit: 255,      default: "", null: false
    t.string   "token4read",     limit: 255,      default: "", null: false
    t.string   "token4write",    limit: 255,      default: "", null: false
    t.integer  "port4console",   limit: 4,        default: 0,  null: false
    t.integer  "port4streaming", limit: 4,        default: 0,  null: false
    t.float    "temp_min",       limit: 24
    t.float    "temp_max",       limit: 24
    t.binary   "picture",        limit: 16777215
    t.string   "memo",           limit: 1024,     default: "", null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "device_id",  limit: 4
    t.integer  "address_id", limit: 4
    t.boolean  "delivered",              default: false, null: false
    t.string   "message",    limit: 255, default: "",    null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "picture_groups", force: :cascade do |t|
    t.integer  "device_id",  limit: 4,                 null: false
    t.boolean  "starred",              default: false, null: false
    t.integer  "head",       limit: 8,                 null: false
    t.integer  "tail",       limit: 8,                 null: false
    t.integer  "n",          limit: 4, default: 0,     null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.integer  "device_id",  limit: 4,                               null: false
    t.datetime "dt",                                                 null: false
    t.boolean  "detected",                    default: false,        null: false
    t.boolean  "starred",                     default: false,        null: false
    t.binary   "data",       limit: 16777215
    t.string   "type",       limit: 64,       default: "image/jpeg", null: false
    t.text     "info",       limit: 65535
    t.string   "memo",       limit: 255,      default: "",           null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "temps", force: :cascade do |t|
    t.integer  "device_id",   limit: 4
    t.datetime "dt"
    t.float    "temperature", limit: 24
    t.float    "pressure",    limit: 24
    t.float    "humidity",    limit: 24
    t.float    "illuminance", limit: 24
    t.float    "voltage",     limit: 24
    t.string   "sender",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "temps", ["device_id", "dt"], name: "index_logs_temps_on_device_id_and_dt", unique: true, using: :btree

  create_table "temps_dailies", force: :cascade do |t|
    t.integer  "device_id",           limit: 4
    t.date     "d"
    t.float    "temperature_average", limit: 24
    t.float    "pressure_average",    limit: 24
    t.float    "humidity_average",    limit: 24
    t.float    "temperature_max",     limit: 24
    t.float    "pressure_max",        limit: 24
    t.float    "humidity_max",        limit: 24
    t.float    "temperature_min",     limit: 24
    t.float    "pressure_min",        limit: 24
    t.float    "humidity_min",        limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "temps_dailies", ["device_id", "d"], name: "index_temps_dailies_on_device_id_and_d", unique: true, using: :btree

  create_table "temps_monthlies", force: :cascade do |t|
    t.integer  "device_id",           limit: 4
    t.integer  "year_month",          limit: 4
    t.float    "temperature_average", limit: 24
    t.float    "pressure_average",    limit: 24
    t.float    "humidity_average",    limit: 24
    t.float    "temperature_max",     limit: 24
    t.float    "pressure_max",        limit: 24
    t.float    "humidity_max",        limit: 24
    t.float    "temperature_min",     limit: 24
    t.float    "pressure_min",        limit: 24
    t.float    "humidity_min",        limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "temps_monthlies", ["device_id", "year_month"], name: "index_temps_monthlies_on_device_id_and_year_month", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "name",                   limit: 255, default: "", null: false
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
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

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
