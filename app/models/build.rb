class Build < ActiveRecord::Base

  belongs_to :project
  belongs_to :user
  has_many :jobs, dependent: :destroy

  validates :project, presence: true
  validates :user, presence: true

  def name
    "#{id} #{revision.truncate(10, omission: '')}"
  end

  def repo_name
    project.repo_name
  end

  def commit
    workspace.commit
  end

  def run_next
    project.tasks.each do |task|
      job = job_for(task)

      case
      when job.nil?
        schedule(task)
        return unless task.parallelizable?
      when job.status == "completed" then next
      when job.status == "running"   then return
      end
    end
  end

  def schedule(task)
    job = jobs.create!(task: task)
    RunJob.perform_later(job)
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

  private

  def add_job(test_file_group, number)
    job = self.jobs.where(number: number).first_or_initialize

    test_file_group.each do |test_file_path|
      job.test_files << TestFile.new(path: test_file_path)
    end

    self.jobs << job
  end

  def job_for(task)
    self.jobs.where(task_id: task.id).first
  end

  def path_to_repo
    project.path_to_repo
  end
end
