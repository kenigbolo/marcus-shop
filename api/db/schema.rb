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

ActiveRecord::Schema[8.0].define(version: 2025_04_20_092301) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "cart_item_options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cart_item_id", null: false
    t.uuid "part_option_id", null: false
    t.decimal "price_applied"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_item_id"], name: "index_cart_item_options_on_cart_item_id"
    t.index ["part_option_id"], name: "index_cart_item_options_on_part_option_id"
  end

  create_table "cart_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.integer "quantity"
    t.uuid "cart_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conditional_prices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "option_id", null: false
    t.uuid "context_option_id", null: false
    t.decimal "price_override", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context_option_id"], name: "index_conditional_prices_on_context_option_id"
    t.index ["option_id", "context_option_id"], name: "index_conditional_prices_on_option_and_context", unique: true
    t.index ["option_id"], name: "index_conditional_prices_on_option_id"
  end

  create_table "option_constraints", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "source_option_id", null: false
    t.uuid "target_option_id", null: false
    t.integer "constraint_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_option_id", "target_option_id", "constraint_type"], name: "index_option_constraints_uniqueness", unique: true
    t.index ["source_option_id"], name: "index_option_constraints_on_source_option_id"
    t.index ["target_option_id"], name: "index_option_constraints_on_target_option_id"
  end

  create_table "part_options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.decimal "base_price"
    t.integer "stock_status"
    t.uuid "part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stock_count", default: 0, null: false
    t.index ["part_id"], name: "index_part_options_on_part_id"
  end

  create_table "parts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_parts_on_product_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.text "description"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cart_item_options", "cart_items"
  add_foreign_key "cart_item_options", "part_options"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "conditional_prices", "part_options", column: "context_option_id"
  add_foreign_key "conditional_prices", "part_options", column: "option_id"
  add_foreign_key "option_constraints", "part_options", column: "source_option_id"
  add_foreign_key "option_constraints", "part_options", column: "target_option_id"
  add_foreign_key "part_options", "parts"
  add_foreign_key "parts", "products"
end
