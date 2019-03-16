class Commentary < ApplicationRecord
  belongs_to :profileable, polymorphic: true
  belongs_to :course
  
  def destroy
    self.is_active = false
    save
  end
end
