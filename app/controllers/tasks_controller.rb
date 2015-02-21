class TasksController < ApplicationController
  before_filter :authorize
  before_filter :load_task, only: [:show, :edit, :update]

  def new
    @task = project.tasks.build(name: "New Task")
  end

  def create
    @task = project.tasks.create!(task_params)
    render "update"
  end

  def update
    @project = @task.project
    @task.update_attributes!(task_params)
  end

  private

  def load_task
    @task = Task.find(params[:id])
  end

  def project
    @project ||= Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:name, :before, :command, :after_sucess, :after_failure)
  end
end
