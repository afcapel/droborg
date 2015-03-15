class LaunchDeployJob < ActiveJob::Base
  queue_as :default

  def perform(deploy)
    deploy.launch
  end
end
