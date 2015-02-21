class Job < ActiveRecord::Base

  belongs_to :build
  belongs_to :task

  delegate :project, :workspace, to: :build

  attr_accessor :not_failed

  scope :started, -> { where('started IS NOT NULL') }

  def run
    puts "Running"
  end

  def finish(result)
    self.update_attributes!(success: result, finished: Time.now)
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
end
