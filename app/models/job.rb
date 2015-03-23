class Job < ActiveRecord::Base
  include Status

  belongs_to :build
  belongs_to :deploy
  belongs_to :task

  delegate :project, :workspace, to: :build

  def run
    self.update!(output: "$ #{task.command}\n\n", status: Status::RUNNING, started_at: Time.now)

    workspace.setup

    result = command.run do |output|
      self.output += output
      self.save!
    end

    if result.success?
      update_attributes!(status: Status::SUCCESS, finished_at: Time.now)
      build.run_next
    else
      update_attributes!(status: Status::FAILED, finished_at: Time.now)
    end
  end

  def elapsed_time
    return 0 unless started_at

    up_to = finished_at || Time.now
    up_to.to_i - started_at.to_i
  end

  def command
    @command ||= ShellCommand.new(task.command, workspace.path, env)
  end

  def env
    build.env.merge(task.env_hash)
  end
end
