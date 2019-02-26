class Solution < ApplicationRecord
  validates :content, presence: true

  belongs_to :assignment
end
