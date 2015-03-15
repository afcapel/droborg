class Deploy::Environment < ActiveRecord::Base

  belongs_to :project
  has_many :deploys, dependent: :destroy, foreign_key: :deploy_environment_id
  has_many :deploy_tasks, class_name: "Deploy::Task", foreign_key: :deploy_environment_id

  def last_deploy
    deploys.order(created_at: :desc).first
  end
end
