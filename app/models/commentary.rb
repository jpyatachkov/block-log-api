class Commentary < ApplicationRecord
  belongs_to :profileable, polymorphic: true

  def destroy
    self.is_active = false
    save
  end
end
