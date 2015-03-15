class AddDeployEnvironmentToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :deploy_environment
  end
end
