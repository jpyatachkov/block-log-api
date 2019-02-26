class Assignment < ApplicationRecord
  validates :text, presence: true

  belongs_to :course
end
