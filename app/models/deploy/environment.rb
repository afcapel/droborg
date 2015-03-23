class Deploy::Environment < ActiveRecord::Base

  belongs_to :project
  has_many :deploys, dependent: :destroy, foreign_key: :deploy_environment_id

  validates :deploy_command, presence: true

  def last_deploy
    deploys.order(created_at: :desc).first
  end

  def current_revision
    last_deploy.revision
  end
end
