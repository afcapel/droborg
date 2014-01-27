class CreateBasicModel < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.timestamps
    end

    create_table :projects do |t|
      t.string :name
      t.integer :workers, default: 1
      t.string :git_url
      t.string :test_files_patterns
      t.text   :env
      t.string :setup_build_command
      t.string :setup_job_command
      t.string :after_job_command
      t.string :after_build_command
      t.timestamps
    end

    create_table :builds do |t|
      t.references :user
      t.references :project
      t.string :branch
      t.string :revision
      t.timestamps
    end

    create_table :jobs do |t|
      t.references :build
      t.integer :number
      t.string :type
      t.boolean :success
      t.text :output
      t.datetime :started
      t.datetime :finished
      t.timestamps
    end

    create_table :test_files do |t|
      t.references :job
      t.string :path
      t.float :last_execution_time
      t.timestamps
    end
  end
end
