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

ActiveRecord::Schema.define(version: 20160404154148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carriers", force: :cascade do |t|
    t.string   "name"
    t.string   "destinations"
    t.integer  "flights"
    t.integer  "cancellations"
    t.integer  "total_taxi_in"
    t.integer  "total_taxi_out"
    t.integer  "total_arr_delay"
    t.integer  "total_dep_delay"
    t.integer  "carrier_delay"
    t.integer  "late_aircraft_delay"
    t.integer  "weather_delay"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "early_arr_num"
    t.integer  "late_arr_num"
    t.integer  "late_dep_num"
    t.float    "arrival_delay_variance"
    t.float    "departure_delay_variance"
  end

  create_table "flights", force: :cascade do |t|
    t.string   "year"
    t.string   "quarter"
    t.string   "month"
    t.string   "daym"
    t.string   "dayw"
    t.string   "date"
    t.string   "carrier"
    t.string   "tailnum"
    t.string   "flightnum"
    t.string   "origin"
    t.string   "o_city"
    t.string   "o_market"
    t.string   "o_state"
    t.string   "dest"
    t.string   "d_city"
    t.string   "d_market"
    t.string   "d_state"
    t.string   "departure_time"
    t.string   "actual_departure"
    t.string   "dep_delay"
    t.string   "dep_time_block"
    t.string   "taxiout"
    t.string   "wheels_off"
    t.string   "wheels_on"
    t.string   "taxi_in"
    t.string   "arrival_time"
    t.string   "actual_arrival"
    t.string   "arr_time_block"
    t.string   "cancelled"
    t.string   "cancel_code"
    t.string   "flight_time"
    t.string   "actual_time"
    t.string   "air_time"
    t.string   "flights"
    t.string   "distance"
    t.string   "carrier_delay"
    t.string   "weather_delay"
    t.string   "nas_delay"
    t.string   "security_delay"
    t.string   "late_aircraft_delay"
    t.string   "first_dep_time"
    t.string   "total_add_gtime"
    t.string   "longest_add_gtime"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

end
