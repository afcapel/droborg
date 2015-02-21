class AddReadyToProject < ActiveRecord::Migration
  def change
    add_column :projects, :ready, :boolean, default: false
  end
end
