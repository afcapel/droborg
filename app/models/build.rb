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

  def finished?
    jobs.all?(&:finished?)
  end

  def pending?
    jobs.any?(&:pending?)
  end

  def started?
    jobs.any?(&:started?)
  end

  def running?
    started? && !finished?
  end

  def success?
    jobs.all?(&:success?)
  end

  def failure?
    finished? && !success?
  end


  def schedule!(numbers = nil)
    files_per_worker = (test_paths.size.to_f/workers).ceil

    parts = test_paths.in_groups_of(files_per_worker, false)
    parts.each_with_index { |number, i| add_job(number, i+1) }

    save!

    self.jobs.each(&:execute!)
  end

  def workers
    project.workers.to_i
  end

  def test_paths
    @test_paths ||= test_files.collect { |p| p.sub("#{path_to_repo}/", '') }
  end

  def workspace
    @workspace ||= Workspace.new(project, revision)
  end

  private

  def add_job(test_file_group, number)
    job = self.jobs.where(number: number).first_or_initialize

    test_file_group.each do |test_file_path|
      job.test_files << TestFile.new(path: test_file_path)
    end

    self.jobs << job
  end

  def test_files
    files_per_pattern = project.test_files_patterns.split(', ').collect do |pattern|
      pattern = pattern.strip
      Dir.glob("#{path_to_repo}/#{pattern}")
    end

    files_per_pattern.flatten
  end

  def path_to_repo
    project.path_to_repo
  end
end
