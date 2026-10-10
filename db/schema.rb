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

ActiveRecord::Schema[8.1].define(version: 2026_10_10_130000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "enrolments", force: :cascade do |t|
    t.integer "academic_year"
    t.datetime "created_at", null: false
    t.string "semester"
    t.bigint "student_id", null: false
    t.bigint "unit_id", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id", "unit_id", "semester", "academic_year"], name: "index_enrolments_on_student_unit_term_unique", unique: true
    t.index ["student_id"], name: "index_enrolments_on_student_id"
    t.index ["unit_id"], name: "index_enrolments_on_unit_id"
  end

  create_table "results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "enrolment_id", null: false
    t.string "grade"
    t.decimal "mark"
    t.datetime "updated_at", null: false
    t.index ["enrolment_id"], name: "index_results_on_enrolment_id"
    t.index ["enrolment_id"], name: "index_results_on_enrolment_id_unique", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "student_number"
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_students_on_course_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "code"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.integer "credit"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_units_on_course_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "role"
    t.datetime "updated_at", null: false
    t.string "username"
  end

  add_foreign_key "enrolments", "students"
  add_foreign_key "enrolments", "units"
  add_foreign_key "results", "enrolments"
  add_foreign_key "students", "courses"
  add_foreign_key "units", "courses"
end
