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

ActiveRecord::Schema.define(version: 20160318105926) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "raspi_id",   limit: 4
    t.string   "mail",       limit: 255
    t.boolean  "active"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer  "raspi_id",   limit: 4
    t.float    "min_tmpr",   limit: 24
    t.float    "max_tmpr",   limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "tmpr_daily_logs", force: :cascade do |t|
    t.integer  "raspi_id",    limit: 4
    t.date     "time_stamp"
    t.float    "temperature", limit: 24
    t.float    "pressure",    limit: 24
    t.float    "humidity",    limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tmpr_logs", force: :cascade do |t|
    t.integer  "raspi_id",    limit: 4
    t.datetime "time_stamp"
    t.float    "temperature", limit: 24
    t.float    "pressure",    limit: 24
    t.float    "humidity",    limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tmpr_monthly_logs", force: :cascade do |t|
    t.integer  "raspi_id",    limit: 4
    t.integer  "year_month",  limit: 4
    t.float    "temperature", limit: 24
    t.float    "pressure",    limit: 24
    t.float    "humidity",    limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end