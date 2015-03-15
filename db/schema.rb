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

ActiveRecord::Schema.define(version: 20150315221624) do

  create_table "builds", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.string   "branch",     limit: 255
    t.string   "revision",   limit: 255
    t.text     "output",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     limit: 255
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "deploy_environments", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "project_id",       limit: 4
    t.string   "current_revision", limit: 255
    t.boolean  "available",        limit: 1
    t.text     "env",              limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "deploy_steps", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "revision",   limit: 255
    t.integer  "project_id", limit: 4
    t.integer  "build_id",   limit: 4
    t.text     "output",     limit: 4294967295
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "deploys", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.string   "revision",              limit: 255
    t.integer  "user_id",               limit: 4
    t.integer  "project_id",            limit: 4
    t.integer  "deploy_environment_id", limit: 4
    t.integer  "build_id",              limit: 4
    t.datetime "deployed_at"
    t.text     "output",                limit: 4294967295
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "status",                limit: 255
  end

  create_table "jobs", force: :cascade do |t|
    t.integer  "build_id",   limit: 4
    t.integer  "task_id",    limit: 4
    t.integer  "number",     limit: 4
    t.string   "type",       limit: 255
    t.boolean  "success",    limit: 1
    t.text     "output",     limit: 4294967295
    t.datetime "started"
    t.datetime "finished"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deploy_id",  limit: 4
  end

  add_index "jobs", ["deploy_id"], name: "index_jobs_on_deploy_id", using: :btree

  create_table "models", force: :cascade do |t|
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "git_url",    limit: 255
    t.text     "env",        limit: 65535
    t.boolean  "ready",      limit: 1,     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "project_id",            limit: 4
    t.string   "name",                  limit: 255
    t.integer  "position",              limit: 4,     default: 1
    t.boolean  "parallelizable",        limit: 1
    t.text     "command",               limit: 65535
    t.text     "env",                   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                  limit: 255
    t.integer  "deploy_environment_id", limit: 4
  end

  create_table "test_files", force: :cascade do |t|
    t.integer  "job_id",              limit: 4
    t.string   "path",                limit: 255
    t.float    "last_execution_time", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "avatar_url",      limit: 255
    t.integer  "github_uid",      limit: 4
    t.string   "github_username", limit: 255
    t.string   "github_token",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "jobs", "deploys"
end
