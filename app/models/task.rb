class Task < ActiveRecord::Base
  include EnvParsing

  has_many :jobs

  acts_as_list scope: :project

  before_destroy :check_no_running_jobs

  private

  def check_no_running_jobs
    errors[:jobs] << "Could not destroy task because it has running jobs" if jobs.running.any?
  end
end
