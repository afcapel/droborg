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

ActiveRecord::Schema.define(version: 20140128232440) do

  create_table "builds", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "branch"
    t.string   "revision"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "output"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "jobs", force: true do |t|
    t.integer  "build_id"
    t.integer  "number"
    t.string   "type"
    t.boolean  "success"
    t.text     "output"
    t.datetime "started"
    t.datetime "finished"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.integer  "workers",             default: 1
    t.string   "git_url"
    t.string   "test_files_patterns"
    t.text     "env"
    t.string   "setup_build_command"
    t.string   "setup_job_command"
    t.string   "after_job_command"
    t.string   "after_build_command"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "build_command"
  end

  create_table "test_files", force: true do |t|
    t.integer  "job_id"
    t.string   "path"
    t.float    "last_execution_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
