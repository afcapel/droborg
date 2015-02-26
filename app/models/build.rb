class Build < ActiveRecord::Base

  STATUSES = [
    SCHEDULED = "Scheduled",
    RUNNING   = "Running",
    FAILED    = "Failed",
    SUCCESS   = "Success",
    UNKNOWN   = "Unknown"
  ]

  belongs_to :project
  belongs_to :user
  has_many :jobs, -> { order(:number) }, dependent: :destroy

  validates :project, presence: true
  validates :user, presence: true

  scope :passing, -> { where(status: SUCCESS) }
  scope :failed,  -> { where(status: SUCCESS) }

  def name
    "#{id} #{revision.truncate(10, omission: '')}"
  end

  def repo_name
    project.repo.name
  end

  def commit
    workspace.commit
  end

  def create_jobs
    project.tasks.each_with_index.collect do |task, index|
      self.jobs.where(task_id: task.id).first_or_create(number: index + 1)
    end

    update_attribute :status, SCHEDULED
  end

  def launch
    workspace.setup
    update_attribute :status, RUNNING
    run_next
  end

  def run_next
    jobs.each do |job|
      case
      when job.pending?
        schedule(job)
        return unless job.task.parallelizable?
      when job.succeded? then next
      when job.failed?
        fail_build
        return
      when job.running?  then return
      end
    end

    # We've run all the jobs
    finish
  end

  def schedule(job)
    job.save! unless job.persisted?
    RunJob.perform_later(job)
  end

  def finish
    if succeded?
      update_attribute :status, RUNNING
    elsif failed?
      update_attribute :status, FAILED
    else
      update_attribute :status, UNKNOWN
    end
  end

  def fail_build
    jobs.not_finished.update_all(finished: Time.now)
  end

  def pending?
    status.in?([SCHEDULED, RUNNING]) && jobs.any? { |j| j.pending? }
  end

  def running?
    jobs.any? { |j| j.running? }
  end

  def finished?
    jobs.all? { |j| j.finished? }
  end

  def succeded?
    status == SUCCESS || jobs.all? { |j| j.succeded? }
  end

  def failed?
    status == FAILED || jobs.any? { |j| j.failed? }
  end

  def workspace
    @workspace ||= Workspace.new(project, revision)
  end

  def env
    {
      'TEST_BUILD'        => id.to_s,
      'TEST_REV'          => revision
    }
  end
end
