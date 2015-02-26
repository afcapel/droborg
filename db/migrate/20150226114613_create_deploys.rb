class CreateDeploys < ActiveRecord::Migration
  def change
    add_column :tasks, :type, :string

    ActiveRecord::Base.connection.execute 'UPDATE tasks SET type="Build::Task"'
    ActiveRecord::Base.connection.execute 'UPDATE jobs  SET type="Build::Job"'

    create_table :deploys do |t|
      t.string :name
      t.string :revision
      t.references :user
      t.references :project
      t.references :build
      t.text :output, limit: 4294967295

      t.timestamps null: false
    end

    create_table :deploy_steps do |t|
      t.string :name
      t.string :revision
      t.references :project
      t.references :build
      t.text :output, limit: 4294967295

      t.timestamps null: false
    end
  end
end
