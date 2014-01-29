class AddBuildCommandToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :build_command, :string
  end
end
