module TasksHelper
  def form_url_for_task(task)
    if task.persisted?
      project_task_path(task.project, task)
    else
      project_tasks_path(task.project)
    end
  end
end
