class Deploy < ActiveRecord::Base
  include TaskRunner

  belongs_to :deploy_environment, class_name: "Deploy::Environment"

  def name
    "#{id} #{deploy_environment.name}"
  end

  def project
    deploy_environment.project
  end

  def tasks
    deploy_environment.deploy_tasks
  end
end
