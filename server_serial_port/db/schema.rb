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

ActiveRecord::Schema.define(version: 20140822113004) do

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
    t.integer  "biblionumber"
    t.string   "author"
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
    t.boolean  "lending"
    t.integer  "setting_id"
    t.float    "weight_error"
    t.float    "size_error"
  end

  create_table "patrons", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patrons", ["email"], name: "index_patrons_on_email", unique: true
  add_index "patrons", ["reset_password_token"], name: "index_patrons_on_reset_password_token", unique: true

  create_table "settings", force: true do |t|
    t.boolean  "debug"
    t.float    "security_level"
    t.float    "size"
    t.float    "similarity"
    t.float    "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "in_use"
    t.string   "description"
    t.float    "min_value"
  end

end
