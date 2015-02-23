class AddGithubInfoToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :password_digest
    add_column :users, :avatar_url, :string
    add_column :users, :github_uid, :integer
    add_column :users, :github_username, :string
    add_column :users, :github_token, :string
  end
end
