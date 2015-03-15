module TasksHelper
  def form_url_for_task(task)
    if task.persisted?
      task_path(task.project, task)
    else
      tasks_path(task.project)
    end
  end
end
