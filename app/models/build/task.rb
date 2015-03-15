class Build::Task < Task
  belongs_to :project

  def first?
    project.build_tasks.first == self
  end

  def last?
    project.build_tasks.last == self
  end

end
