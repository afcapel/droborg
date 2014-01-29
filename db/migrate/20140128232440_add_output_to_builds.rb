class AddOutputToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :output, :text
  end
end
