module Status
  extend ActiveSupport::Concern

  SCHEDULED = "Scheduled"
  RUNNING   = "Running"
  FAILED    = "Failed"
  SUCCESS   = "Success"

  ALL = [
    SCHEDULED,
    RUNNING,
    FAILED,
    SUCCESS
  ]

  included do
    scope :started,      -> { where(status: [RUNNING, FAILED, SUCCESS]) }
    scope :not_finished, -> { where(status: [SCHEDULED, RUNNING]) }
    scope :running,      -> { where(status: RUNNING) }

    before_create :set_status
  end

  def pending?
    status == SCHEDULED
  end

  def started?
    status.in? [RUNNING, FAILED, SUCCESS]
  end

  def running?
    status == RUNNING
  end

  def finished?
    status.in? [FAILED, SUCCESS]
  end

  def failed?
    status == FAILED
  end

  def succeded?
    status == SUCCESS
  end

  private

  def set_status
    self.status ||= Status::SCHEDULED
  end
end
