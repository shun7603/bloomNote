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

ActiveRecord::Schema[7.1].define(version: 2025_05_16_022107) do
  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "care_relationships", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "parent_id", null: false
    t.bigint "caregiver_id", null: false
    t.bigint "child_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caregiver_id"], name: "index_care_relationships_on_caregiver_id"
    t.index ["child_id"], name: "index_care_relationships_on_child_id"
    t.index ["parent_id"], name: "index_care_relationships_on_parent_id"
  end

  create_table "children", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gender", default: 0, null: false
    t.index ["user_id"], name: "index_children_on_user_id"
  end

  create_table "hospitals", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "child_id", null: false
    t.index ["child_id"], name: "index_hospitals_on_child_id"
    t.index ["user_id"], name: "index_hospitals_on_user_id"
  end

  create_table "notifications", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "routine_id", null: false
    t.string "message", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["routine_id"], name: "index_notifications_on_routine_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "child_id", null: false
    t.integer "record_type"
    t.integer "quantity"
    t.text "memo"
    t.datetime "recorded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.bigint "user_id"
    t.index ["child_id"], name: "index_records_on_child_id"
  end

  create_table "routines", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "child_id", null: false
    t.time "time", null: false
    t.string "task", null: false
    t.text "memo"
    t.boolean "important", default: false
    t.integer "quantity"
    t.integer "count"
    t.float "temperature"
    t.string "condition"
    t.string "medicine_name"
    t.string "hospital_name"
    t.string "event_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_routines_on_child_id"
  end

  create_table "subscriptions", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "endpoint", null: false
    t.string "p256dh_key", null: false
    t.string "auth_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["endpoint"], name: "index_subscriptions_on_endpoint", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nickname", null: false
    t.integer "role", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "subscription_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "care_relationships", "children"
  add_foreign_key "care_relationships", "users", column: "caregiver_id"
  add_foreign_key "care_relationships", "users", column: "parent_id"
  add_foreign_key "children", "users"
  add_foreign_key "hospitals", "children"
  add_foreign_key "hospitals", "users"
  add_foreign_key "notifications", "routines"
  add_foreign_key "notifications", "users"
  add_foreign_key "records", "children"
  add_foreign_key "routines", "children"
  add_foreign_key "subscriptions", "users"
end
