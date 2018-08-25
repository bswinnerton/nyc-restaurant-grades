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

ActiveRecord::Schema.define(version: 2017_03_12_170343) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inspections", id: :serial, force: :cascade do |t|
    t.integer "restaurant_id"
    t.text "type"
    t.datetime "inspected_at"
    t.datetime "graded_at"
    t.integer "score"
    t.text "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id", "inspected_at"], name: "index_inspections_on_restaurant_id_and_inspected_at", unique: true
  end

  create_table "restaurants", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "camis"
    t.text "building_number"
    t.text "street"
    t.text "zipcode"
    t.integer "borough"
    t.text "cuisine"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "phone_number"
    t.index ["camis"], name: "index_restaurants_on_camis", unique: true
  end

  create_table "violations", id: :serial, force: :cascade do |t|
    t.text "description"
    t.text "code"
    t.integer "inspection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inspection_id", "code"], name: "index_violations_on_inspection_id_and_code", unique: true
  end

end
