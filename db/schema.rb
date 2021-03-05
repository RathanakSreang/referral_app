# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_04_160128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.integer "user_id"
    t.string "token", default: ""
    t.datetime "expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expires_at"], name: "index_access_tokens_on_expires_at"
    t.index ["token"], name: "index_access_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_access_tokens_on_user_id"
  end

  create_table "referrals", force: :cascade do |t|
    t.integer "referrer_id"
    t.float "referrer_credit", default: 0.0
    t.float "user_credit", default: 0.0
    t.integer "usage_count", default: 0
    t.integer "reward_per_usage", default: 0
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_referrals_on_code", unique: true
    t.index ["referrer_id"], name: "index_referrals_on_referrer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: ""
    t.string "email", default: ""
    t.string "password_digest"
    t.float "balance", default: 0.0
    t.string "referral_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
