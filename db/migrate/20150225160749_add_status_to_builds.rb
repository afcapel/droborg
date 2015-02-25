class AddStatusToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :status, :string
  end
end
