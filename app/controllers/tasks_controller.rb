class TasksController < ApplicationController
  before_filter :authorize
  before_filter :task, only: [:show, :edit]

  def new
    @task = project.tasks.build(name: "New Task")
  end

  def create
    task = project.tasks.create!(task_params)
    render "update"
  end

  def update
    project = task.project
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
    @task ||= project.tasks.find(params[:id])
  end

  def project
    @project ||= Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:name, :command, :env)
  end
end
