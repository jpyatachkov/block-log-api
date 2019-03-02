class Assignment < ApplicationRecord
  resourcify
  validates :text, presence: true

  belongs_to :course
end
