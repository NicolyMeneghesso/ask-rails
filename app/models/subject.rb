class Subject < ApplicationRecord
  has_many :questions
  # Kaminari
  paginates_per 6
end
