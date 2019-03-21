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

ActiveRecord::Schema.define(version: 2019_03_20_140203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignment_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "assignment_id"
    t.integer "assignment_mark", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_assignment_users_on_assignment_id"
    t.index ["user_id"], name: "index_assignment_users_on_user_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.text "text"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "tests"
    t.bigint "user_id"
    t.index ["course_id"], name: "index_assignments_on_course_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "commentaries", force: :cascade do |t|
    t.text "comment"
    t.boolean "is_active", default: true
    t.integer "user_id"
    t.string "username"
    t.string "profileable_type"
    t.bigint "profileable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id"
    t.index ["course_id"], name: "index_commentaries_on_course_id"
    t.index ["profileable_type", "profileable_id"], name: "index_commentaries_on_profileable_type_and_profileable_id"
    t.index ["username"], name: "index_commentaries_on_username"
  end

  create_table "course_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.integer "course_mark", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_users_on_course_id"
    t.index ["user_id", "course_id"], name: "index_course_users_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_course_users_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "is_active", default: true
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.text "content"
    t.bigint "assignment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "course_id"
    t.index ["assignment_id"], name: "index_solutions_on_assignment_id"
    t.index ["course_id"], name: "index_solutions_on_course_id"
    t.index ["user_id"], name: "index_solutions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.boolean "is_staff", default: false
    t.boolean "is_admin", default: false
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "assignment_users", "assignments"
  add_foreign_key "assignment_users", "users"
  add_foreign_key "assignments", "courses"
  add_foreign_key "assignments", "users"
  add_foreign_key "commentaries", "courses"
  add_foreign_key "course_users", "courses"
  add_foreign_key "course_users", "users"
  add_foreign_key "courses", "users"
  add_foreign_key "solutions", "assignments"
  add_foreign_key "solutions", "courses"
  add_foreign_key "solutions", "users"
end
