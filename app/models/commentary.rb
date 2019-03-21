class Commentary < ApplicationRecord
  belongs_to :profileable, polymorphic: true
  belongs_to :course

  validates :comment, presence: true

  def destroy
    self.is_active = false
    save
  end
end
