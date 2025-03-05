class Question < ApplicationRecord
  belongs_to :subject

  #Kaminari
  paginates_per 6
end
