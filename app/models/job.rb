class Job < ActiveRecord::Base

  belongs_to :build
  belongs_to :deploy
  belongs_to :task

  delegate :project, :workspace, to: :build

  attr_accessor :not_failed

  scope :started,      -> { where("started IS NOT NULL") }
  scope :not_finished, -> { where("finished IS NULL") }
  scope :running,      -> { started.not_finished }

  def run
    self.not_failed = true
    self.update_attributes(output: '', started: Time.now)

    execute(task.command) if task.command.present?

    finish(not_failed)

  rescue Exception => ex
    self.not_failed = false
    self.output += "\nError executing job: #{ex.message}"
    self.output += ex.backtrace.join("\n")

    finish(false)
  end

  def execute(command)
    self.output += "$ #{command}\n"

    workspace.execute(command, env) do |stdin, stdout_and_stderr, wait_thread|
      while line = stdout_and_stderr.gets
        self.output += line
        save!
      end

      exit_status = wait_thread.value
      self.not_failed = not_failed && exit_status.success?
    end
  end

  def finish(result)
    self.update_attributes!(success: result, finished: Time.now)
    build.run_next
  end

  def elapsed_time
    return 0 unless started

    up_to = finished || Time.now
    up_to.to_i - started.to_i
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

  def failed?
    finished? && !succeded?
  end

  def succeded?
    success
  end

  def env
    build.env.merge(task.env_hash)
  end
end
