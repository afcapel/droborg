class RunJob < ActiveJob::Base
  queue_as :default

  def perform(job)
    job.run
  end
end
