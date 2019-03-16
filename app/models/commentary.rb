class Commentary < ApplicationRecord
  belongs_to :profileable, polymorphic: true
end
