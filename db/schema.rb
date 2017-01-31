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

ActiveRecord::Schema.define(version: 20170129111324) do

  create_table "cities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.string   "code",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_cities_on_code", using: :btree
    t.index ["name"], name: "index_cities_on_name", using: :btree
  end

  create_table "parkings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                                                        null: false
    t.string   "address",                                                     null: false
    t.integer  "total_car_spots",                                             null: false
    t.integer  "total_bike_spots",                                            null: false
    t.integer  "aval_car_spots",                                              null: false
    t.integer  "aval_bike_spots",                                             null: false
    t.integer  "car_price_paisas",                            default: 0,     null: false
    t.string   "car_price_currency",                          default: "INR", null: false
    t.integer  "bike_price_paisas",                           default: 0,     null: false
    t.string   "bike_price_currency",                         default: "INR", null: false
    t.decimal  "longitude",           precision: 8, scale: 6
    t.decimal  "latitude",            precision: 8, scale: 6
    t.integer  "city_id"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.index ["address"], name: "index_parkings_on_address", using: :btree
    t.index ["city_id"], name: "index_parkings_on_city_id", using: :btree
  end

  create_table "tickets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "token"
    t.string   "license"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "vehicle_type"
    t.datetime "checkin_time"
    t.datetime "checkout_time"
    t.integer  "booked_hours"
    t.integer  "status"
    t.integer  "online_amount_paisas",    default: 0,     null: false
    t.string   "online_amount_currency",  default: "INR", null: false
    t.integer  "offline_amount_paisas",   default: 0,     null: false
    t.string   "offline_amount_currency", default: "INR", null: false
    t.integer  "total_amount_paisas",     default: 0,     null: false
    t.string   "total_amount_currency",   default: "INR", null: false
    t.integer  "parking_id"
    t.integer  "user_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["phone_number"], name: "index_tickets_on_phone_number", using: :btree
    t.index ["status"], name: "index_tickets_on_status", using: :btree
    t.index ["token"], name: "index_tickets_on_token", using: :btree
    t.index ["user_id"], name: "index_tickets_on_user_id", using: :btree
  end

end
