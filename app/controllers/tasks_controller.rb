class TasksController < ApplicationController
  before_filter :authorize
  before_filter :task, only: [:show, :edit]

  def new
    @task = scope.build(name: "New Task")
  end

  def create
    @task = scope.create!(task_params)
    render "update"
  end

  def update
    task.update_attributes!(task_params)
  end

  def destroy
    task.destroy
  end

  def move
    if params[:move] == "up"
      task.move_higher
    else
      task.move_lower
    end
  end

  private

  def task
    @task ||= scope.find(params[:id])
  end

  def project
    @project ||= Project.find(params[:project_id])
  end

  def environment
    @environment ||= Deploy::Environment.find(params[:environment_id])
  end

  def task_params
    (params[:build_task] || params[:deploy_task])
      .permit(:deploy_environment_id, :project_id, :name, :parallelizable, :command, :env, :type)
  end

  def scope
    if params[:project_id].present?
      project.build_tasks
    elsif params[:environment_id].present?
      environment.deploy_tasks
    else
      Task
    end
  end
end
