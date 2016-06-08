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

ActiveRecord::Schema.define(version: 20160608204459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inspections", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.text     "type"
    t.datetime "inspected_at"
    t.datetime "graded_at"
    t.integer  "score"
    t.text     "violation_description"
    t.text     "violation_code"
    t.text     "grade"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "restaurants", force: :cascade do |t|
    t.text     "name"
    t.text     "camis"
    t.text     "building_number"
    t.text     "street"
    t.text     "zipcode"
    t.integer  "borough"
    t.text     "cuisine"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "phone_number"
  end

end
