class CreateInheritances < ActiveRecord::Migration
  def change
    # Tables inherited from version 1.
    # dt = timestamp as id, d = date as id
    #

    create_table "addresses", force: :cascade do |t|
      t.integer  "device_id",     limit: 4
      t.string   "address_type",  limit: 255, default: "", null: false # phone, email, LINE, etc..
      t.string   "address",       limit: 255, default: "", null: false
      t.integer  "snooze",        limit: 4,   default: 60, null: false # interval(min) for notifications
      t.boolean  "active",        null: false, default: true
      t.datetime "created_at",                             null: false
      t.datetime "updated_at",                             null: false
    end
    add_index "addresses", ["device_id", "address"], name: "index_addresses_on_device_id_and_address", unique: true, using: :btree

    create_table "devices", force: :cascade do |t|
      t.integer  "user_id",     limit: 4
      t.integer  "city_id",     limit: 8
      t.string   "device_type", limit: 255, null: false, default: "" # raspi, arduino, sakuraio, etc..
      t.string   "name",        limit: 255, null: false, default: ""
      t.string   "token4read",  limit: 255, null: false, default: ""
      t.string   "token4write", limit: 255, null: false, default: ""
      t.string   "token4sakura",limit: 255, null: false, default: ""
      t.integer "port4console",   limit: 4, null: false, default: 0
      t.integer "port4streaming", limit: 4, null: false, default: 0
      t.float    "temp_min",    limit: 24
      t.float    "temp_max",    limit: 24
      t.binary   "picture",     limit: 16777215 # image/jpeg 640x640, used for storing the picture of the device itself.
      t.string   "memo",        limit: 1024,null: false, default: ""
      t.datetime "created_at",              null: false
      t.datetime "updated_at",              null: false
    end

    create_table "pictures", force: :cascade do |t|
      t.integer  "device_id",  limit: 4,             null: false
      t.datetime "dt",                               null: false
      t.boolean  "detected",         default: false, null: false # true if something moved
      t.boolean  "starred",          default: false, null: false
      t.binary   "data",  limit: 16777215
      t.string   "data_type",  limit: 64, default: "image/jpeg", null: false  # movie gif etc..
      t.text     "info",  limit: 60000  # additional information
      t.string   "memo",  limit: 255,default: "",    null: false
      t.datetime "created_at",                       null: false
      t.datetime "updated_at",                       null: false
    end
    add_index "pictures", ["device_id", "dt"], name: "index_pictures_on_device_id_and_dt", unique: true, using: :btree

    create_table "picture_groups", force: :cascade do |t|
      t.integer  "device_id",  limit: 4,                 null: false
      t.boolean  "starred",              default: false, null: false
      t.integer  "head",       limit: 8,                 null: false
      t.integer  "tail",       limit: 8,                 null: false
      t.integer  "n",          limit: 4, default: 0,     null: false
      t.datetime "created_at",                           null: false
      t.datetime "updated_at",                           null: false
    end

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

    create_table "notifications", force: :cascade do |t|
      t.integer  "device_id", limit: 4
      t.integer  "address_id", limit: 4
      t.boolean  "delivered",  null: false, default: false # true if the notification had sent correctly
      t.string   "message",    limit: 255, default: "", null: false
      t.datetime "created_at",           null: false
      t.datetime "updated_at",           null: false
    end

    create_table "temps", force: :cascade do |t|
      t.integer  "device_id",   limit: 4
      t.datetime "dt"
      t.float    "temperature", limit: 24
      t.float    "pressure",    limit: 24
      t.float    "humidity",    limit: 24
      t.float    "illuminance", limit: 24
      t.float    "voltage",     limit: 24   # to check the health state of the device
      t.string   "sender",      limit: 255
      t.datetime "created_at",              null: false
      t.datetime "updated_at",              null: false
    end

    add_index "temps", ["device_id", "dt"], name: "index_temps_on_device_id_and_dt", unique: true, using: :btree

    create_table "temps_dailies", force: :cascade do |t|
      t.integer  "device_id",            limit: 4
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
      t.integer  "device_id",            limit: 4
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

  end
end
