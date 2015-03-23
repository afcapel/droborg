class Deploy < ActiveRecord::Base
  include Status

  belongs_to :user
  belongs_to :build
  belongs_to :deploy_environment, class_name: "Deploy::Environment"
  has_one :project, through: :deploy_environment

  delegate :revision, :workspace, :commit, to: :build

  def launch
    self.update!(output: "$ #{deploy_environment.deploy_command}\n\n", status: Status::RUNNING, started_at: Time.now)

    workspace.setup

    result = command.run do |output|
      self.output += output
      self.save!
    end

    if result.success?
      assign_attributes(status: Status::SUCCESS, finished_at: Time.now)
    else
      self.status = Status::FAILED
    end

    save!
  end

  def command
    @command ||= ShellCommand.new(deploy_environment.deploy_command, workspace.path)
  end
end
