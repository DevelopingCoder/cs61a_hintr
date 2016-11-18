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

<<<<<<< 95b7b7e2d50f1aa6e7d83b025b4e0855c758743f
ActiveRecord::Schema.define(version: 20161123033515) do
=======
ActiveRecord::Schema.define(version: 20161116011324) do
>>>>>>> set up dbs for questions and wrong answers

  create_table "concepts", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.string  "msg_status",         default: "no messages"
    t.integer "lab_first_appeared"
  end

<<<<<<< 95b7b7e2d50f1aa6e7d83b025b4e0855c758743f
  add_index "concepts", ["name"], name: "index_concepts_on_name"
=======
  create_table "hint_votes", force: :cascade do |t|
    t.integer "vote_type"
    t.integer "user_id"
    t.integer "hint_id"
  end

  create_table "hints", force: :cascade do |t|
    t.string   "content"
    t.boolean  "finalized"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag2wronganswer_id"
  end
>>>>>>> set up dbs for questions and wrong answers

  create_table "messages", force: :cascade do |t|
    t.string   "content"
    t.string   "author"
    t.integer  "concept_id"
    t.boolean  "finalized"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

<<<<<<< 95b7b7e2d50f1aa6e7d83b025b4e0855c758743f
  add_index "messages", ["content"], name: "index_messages_on_content"
=======
  create_table "question_sets", force: :cascade do |t|
    t.string "name"
  end

  create_table "questions", force: :cascade do |t|
    t.string  "text"
    t.string  "case_string"
    t.integer "question_set_id"
  end
>>>>>>> set up dbs for questions and wrong answers

  create_table "tag2concept", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "concept_id"
  end

  create_table "tag2wronganswers", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "wrong_answer_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "example"
    t.string "topic"
  end

  add_index "tags", ["name"], name: "index_tags_on_name"

  create_table "users", force: :cascade do |t|
    t.string   "name"
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
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "votes", force: :cascade do |t|
    t.integer "vote_type"
    t.integer "user_id"
    t.integer "message_id"
  end

  create_table "wrong_answers", force: :cascade do |t|
    t.string  "text"
    t.integer "question_id"
  end

end
