class Deploy::Task < Task

  belongs_to :deploy_environment, class_name: "Deploy::Environment"

  def first?
    deploy_environment.deploy_tasks.first == self
  end

  def last?
    deploy_environment.deploy_tasks.last == self
  end
end
