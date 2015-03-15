class AddDeployIdToJobs < ActiveRecord::Migration
  def change
    add_column :deploys, :status, :string

    add_reference :jobs, :deploy, index: true
    add_foreign_key :jobs, :deploys
  end
end
