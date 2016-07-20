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

ActiveRecord::Schema.define(version: 20160720043106) do

  create_table "answers", force: :cascade do |t|
    t.integer  "query_id"
    t.integer  "train_datum_id"
    t.integer  "score"
    t.float    "similarytyRatio"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "correct_answers", force: :cascade do |t|
    t.integer  "query_id"
    t.integer  "train_datum_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "queries", force: :cascade do |t|
    t.string   "fd_algorithm"
    t.string   "de_algorithm"
    t.string   "option_name"
    t.string   "version"
    t.string   "query_image_path"
    t.integer  "query_keypoints_count"
    t.time     "query_datetime"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "train_data", force: :cascade do |t|
    t.string   "jan"
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
