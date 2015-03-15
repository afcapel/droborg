class Build < ActiveRecord::Base
  include TaskRunner

  belongs_to :project
  belongs_to :user

  validates :project, presence: true
  validates :user, presence: true

  def tasks
    project.tasks
  end

  def name
    "#{id} #{revision.truncate(10, omission: '')}"
  end
end
