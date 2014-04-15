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

ActiveRecord::Schema.define(version: 20140415140705) do

  create_table "books", force: true do |t|
    t.string   "barcode"
    t.float    "weight"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "other_weight"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.float    "size_width"
    t.float    "size_height"
  end

  create_table "lendings", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.float    "size_width"
    t.float    "size_height"
    t.float    "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.float    "ssim"
    t.float    "rmse"
    t.float    "security_value"
  end

end
