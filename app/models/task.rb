class Task < ActiveRecord::Base
  include EnvParsing

  belongs_to :project
  has_many :jobs

  acts_as_list scope: :project

  before_destroy :check_no_running_jobs

  def first?
    project.build_tasks.first == self
  end

  def last?
    project.build_tasks.last == self
  end

  private

  def check_no_running_jobs
    errors[:jobs] << "Could not destroy task because it has running jobs" if jobs.running.any?
  end
end
