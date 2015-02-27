class CreateDeploys < ActiveRecord::Migration
  def change
    add_column :tasks, :type, :string

    ActiveRecord::Base.connection.execute 'UPDATE tasks SET type="Build::Task"'

    create_table :deploy_environments do |t|
      t.string :name
      t.references :project
      t.string :current_revision
      t.boolean :available
      t.text   :env

      t.timestamps null: false
    end

    create_table :deploys do |t|
      t.string :name
      t.string :revision
      t.references :user
      t.references :project
      t.references :deploy_environment
      t.references :build
      t.datetime :deployed_at
      t.text :output, limit: 4294967295

      t.timestamps null: false
    end
  end
end
