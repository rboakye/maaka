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

ActiveRecord::Schema.define(version: 20140214095316) do

  create_table "comments", force: true do |t|
    t.text     "kasa_comment", null: false
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_uuid",    null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "image_comments", force: true do |t|
    t.integer  "image_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "image_comments", ["comment_id", "image_id"], name: "index_image_comments_on_comment_id_and_image_id", using: :btree

  create_table "images", force: true do |t|
    t.text     "image_description"
    t.string   "creator"
    t.string   "image_uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "post_by",                      null: false
    t.text     "post_content",                 null: false
    t.boolean  "is_private",   default: false, null: false
    t.string   "post_uuid",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_connected", default: false
    t.integer  "connected_id"
  end

  create_table "user_images", force: true do |t|
    t.integer  "user_id"
    t.integer  "image_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_images", ["user_id", "image_id"], name: "index_user_images_on_user_id_and_image_id", using: :btree

  create_table "user_posts", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_posts", ["user_id", "post_id"], name: "index_user_posts_on_user_id_and_post_id", using: :btree

  create_table "user_sessions", force: true do |t|
    t.boolean  "is_online",  default: false
    t.datetime "last_seen"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_sessions", ["user_id"], name: "index_user_sessions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",          null: false
    t.string   "last_name",           null: false
    t.string   "email",               null: false
    t.string   "user_uuid",           null: false
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "current_city"
    t.string   "phone"
    t.string   "gender"
    t.text     "about_me"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.date     "birth_date"
    t.string   "user_name"
  end

end
