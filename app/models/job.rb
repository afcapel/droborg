class Job < ActiveRecord::Base

  SPEC_PATTERN      = /.*_spec\.rb/
  TEST_UNIT_PATTERN = /.*_test\.rb/

  ALLOWED_ENV_VARS = %w{HOME SHELL LC_ALL SHELL LC_CTYPE DISPLAY RBENV_ROOT}

  belongs_to :build
  has_many :test_files, dependent: :destroy

  delegate :project, :workspace, to: :build
  delegate :setup_job_command, :after_job_command, to: :project

  attr_accessor :not_failed

  scope :started, -> { where('started IS NOT NULL') }

  def execute!
    self.not_failed = true
    self.update_attributes(output: '', started: Time.now)

    execute(setup_job_command)      if setup_job_command.present?
    execute(test_unit_test_command) if test_unit_paths.present?
    execute(spec_test_command)      if spec_paths.present?

    finish(not_failed)

  rescue Exception => ex
    self.not_failed = false
    self.output += "\nError executing job: #{ex.message}"

    finish(false)
  end
  handle_asynchronously :execute!

  def execute(command)
    self.output += "$ #{command}\n"

    exit_status = workspace.execute(command, child_env) do |stdin, stdout_err, wait_thread|
      while line = stdout_err.gets
        self.output += line
        save!
      end

      exit_status = wait_thread.value
      self.not_failed = not_failed && exit_status.success?
    end
  end

  def child_env
    child_env = ENV.to_h.slice(*ALLOWED_ENV_VARS)

    paths = ENV['PATH'].split(':').reject do |p|
      p.include? "#{ENV['RBENV_ROOT']}/versions"
    end

    child_env['PATH'] = paths.join(':')

    if File.exist? "#{workspace.path}/.ruby-version"
      child_env['RBENV_VERSION'] = File.read("#{workspace.path}/.ruby-version").strip
    end

    child_env['TEST_BUILD']        = build.id.to_s
    child_env['TEST_WORKER_INDEX'] = number.to_s
    child_env['TEST_REV']          = build.revision
    child_env['TEST_ENV_NUMBER']   = "_#{build.id}_#{number}"

    child_env.merge!(project.env_hash)

    child_env
  end

  def finish(result)
    self.update_attributes!(success: result, finished: Time.now)
  end

  def test_unit_test_command
    "ruby -I.:test -e \"ARGV.each{|f| require f}\" #{test_unit_paths.join(' ')}"
  end

  def spec_test_command
    "bundle exec rspec #{spec_paths.join(' ')}"
  end

  def pending?
    started.blank?
  end

  def started?
    started.present?
  end

  def running?
    started? && !finished?
  end

  def finished?
    finished.present?
  end

  def failure?
    finished? && !success?
  end

  def spec_paths
    @spec_paths ||= test_paths.select { |path| path =~ SPEC_PATTERN }
  end

  def test_unit_paths
    @test_unit_paths ||= test_paths.select { |path| path =~ TEST_UNIT_PATTERN }
  end

  def test_paths
    test_files.collect(&:path)
  end
end
