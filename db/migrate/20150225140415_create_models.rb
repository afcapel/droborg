class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|

      create_table "builds", force: :cascade do |t|
        t.integer  "user_id",    limit: 4
        t.integer  "project_id", limit: 4
        t.string   "branch",     limit: 255
        t.string   "revision",   limit: 255
        t.text     "output",     limit: 65535
        t.datetime "created_at"
        t.datetime "updated_at"
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
      end

      create_table "projects", force: :cascade do |t|
        t.string   "name",                limit: 255
        t.string   "git_url",             limit: 255
        t.text     "env",                 limit: 65535
        t.boolean  "ready",               limit: 1,     default: false
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "tasks", force: :cascade do |t|
        t.integer  "project_id",     limit: 4
        t.string   "name",           limit: 255
        t.integer  "position",       limit: 4,     default: 1
        t.boolean  "parallelizable", limit: 1
        t.text     "command",        limit: 65535
        t.text     "env",                 limit: 65535
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
    end
  end
end
