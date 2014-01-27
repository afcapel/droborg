class TestFile < ActiveRecord::Base
  belongs_to :job

  validates :path, presence: true
end