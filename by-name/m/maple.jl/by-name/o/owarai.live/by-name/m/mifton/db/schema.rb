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

ActiveRecord::Schema.define(version: 2019_11_15_141452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "authorities", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manage_pos", default: "general"
    t.string "dev_pos", default: "none"
    t.integer "donor_amount", default: 0
  end

  create_table "bookmarks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.string "image_name"
    t.string "parent_model"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contest_join_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "contest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contest_records", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "contest_id"
    t.integer "primary_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contests", force: :cascade do |t|
    t.string "name"
    t.integer "times"
    t.datetime "start_datetime"
    t.integer "duration"
    t.integer "rated_range"
    t.integer "penalty"
    t.string "contest_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "direct_messages", force: :cascade do |t|
    t.string "message"
    t.integer "user_id"
    t.string "target_user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "draft_contests", force: :cascade do |t|
    t.string "name"
    t.integer "times"
    t.datetime "start_datetime"
    t.integer "rated_range"
    t.integer "penalty"
    t.string "contest_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration"
  end

  create_table "draft_microposts", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "draft_questions", force: :cascade do |t|
    t.integer "contest_id"
    t.string "title"
    t.string "writer"
    t.integer "score"
    t.text "content"
    t.text "constraints"
    t.text "input_example"
    t.text "output_example"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "draft_topics", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_name"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "kind"
    t.bigint "user_id"
    t.string "target"
    t.boolean "is_public"
    t.integer "from_user"
    t.string "from_service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.string "writer"
    t.integer "score"
    t.text "content"
    t.text "constraints"
    t.text "input_example"
    t.text "output_example"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "contest_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "rate_value"
    t.string "contest_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reactions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "reactioned_id"
    t.string "reactioned_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "replies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer "user_id"
    t.integer "reported_object_id"
    t.string "reported_object_type"
    t.integer "report_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reposts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer "micropost_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_birthdays", force: :cascade do |t|
    t.bigint "user_id"
    t.date "birthday"
    t.string "publish_years", default: "publish"
    t.string "publish_date", default: "publish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_traffics", force: :cascade do |t|
    t.integer "user_id"
    t.text "profile"
    t.string "location"
    t.string "user_link"
    t.date "birthday"
    t.string "platform"
    t.string "twitter_id"
    t.string "lobi_id"
    t.string "github_id"
    t.string "discord_id"
    t.integer "user_score", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.text "profile"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reported_value", default: 0
    t.integer "trusted_value", default: 0
    t.boolean "is_test_user", default: false
    t.string "user_id", null: false
    t.string "image_name", default: "default_icon.png"
    t.string "remember_digest"
    t.string "header_image_name", default: "default_header.png"
    t.string "data_os"
    t.string "data_sns"
    t.string "data_where_know"
    t.string "provider"
    t.string "uid"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "microposts", "users"
end
