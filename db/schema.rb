# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_01_190547) do
  create_table "aircraft_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "aircraft_id"
  end

  create_table "aircrafts", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "group"
    t.date "last_maintenance"
    t.boolean "active_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flights", force: :cascade do |t|
    t.integer "reservation_id"
    t.date "flight_date"
    t.integer "aircraft_id"
    t.integer "flight_time"
    t.integer "tow_height"
    t.boolean "rope_break"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "hours", force: :cascade do |t|
    t.string "hour"
    t.boolean "active_flag"
  end

  create_table "membership_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "membership_id"
    t.date "renewal_date"
    t.boolean "active_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.string "membership_type"
    t.integer "renewal_period"
    t.integer "renewal_price"
    t.boolean "active_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "user_admin"
    t.boolean "club_admin"
    t.boolean "site_admin"
    t.boolean "global_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "user_id"
    t.date "reservation_date"
    t.string "reservation_time"
    t.integer "reservation_duration"
    t.integer "aircraft_id"
    t.boolean "instructor_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
