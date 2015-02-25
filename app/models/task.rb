class Task < ActiveRecord::Base
  belongs_to :project
  has_many :jobs

  acts_as_list scope: :project

  before_destroy :check_no_running_jobs

  def first?
    project.tasks.first == self
  end

  def last?
    project.tasks.last == self
  end

  private

  def check_no_running_jobs
    errors[:jobs] << "Could not destroy task because it has running jobs" if jobs.running.any?
  end
end
