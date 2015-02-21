class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :project
      t.string :name
      t.boolean :parallelizable
      t.text :command
      t.text :after_success
      t.text :after_failure
      t.timestamps
    end

    add_reference :jobs, :task
  end

  def self.up
    remove_column :projects, :test_files_patterns
    remove_column :projects, :setup_build_command
    remove_column :projects, :setup_job_command
    remove_column :projects, :after_job_command
    remove_column :projects, :after_build_command
    remove_column :projects, :build_command
  end

  def self.down
    add_column :projects, :test_files_patterns, :string
    add_column :projects, :setup_build_command, :string
    add_column :projects, :setup_job_command, :string
    add_column :projects, :after_job_command, :string
    add_column :projects, :after_build_command, :string
    add_column :projects, :build_command, :string
  end
end
