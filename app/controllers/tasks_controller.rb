class TasksController < ApplicationController
  before_filter :authorize
  before_filter :task, only: [:show, :edit]

  def new
    @task = project.build_tasks.build(name: "New Task")
  end

  def create
    task = project.build_tasks.create!(task_params)
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
    @task ||= project.build_tasks.find(params[:id])
  end

  def project
    @project ||= Project.find(params[:project_id])
  end

  def task_params
    params.require(:build_task).permit(:name, :command, :env, :type)
  end
end
