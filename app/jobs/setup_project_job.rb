class SetupProjectJob < ActiveJob::Base
  queue_as :default

  def perform(project)
    project.setup
  end
end
