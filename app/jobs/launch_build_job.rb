class LaunchBuildJob < ActiveJob::Base
  queue_as :default

  def perform(build)
    build.launch
  end
end
