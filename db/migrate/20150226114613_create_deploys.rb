class CreateDeploys < ActiveRecord::Migration
  def change
    create_table :deploy_environments do |t|
      t.string :name
      t.references :project
      t.string :current_revision
      t.boolean :available
      t.string  :deploy_command

      t.timestamps null: false
    end

    create_table :deploys do |t|
      t.string :status
      t.references :user
      t.references :deploy_environment
      t.references :build

      t.datetime :started_at
      t.datetime :finished_at

      t.text :output, limit: 4294967295

      t.timestamps null: false
    end
  end
end
