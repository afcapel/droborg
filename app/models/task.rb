class Task < ActiveRecord::Base
  belongs_to :project
  has_many :jobs

  before_destroy :check_no_running_jobs

  private

  def check_no_running_jobs
    errors[:jobs] << "Could not destroy task because it has running jobs" if jobs.running.any?
  end
end
