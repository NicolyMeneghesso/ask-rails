class Question < ApplicationRecord
  belongs_to :subject
  has_many :answers
  accepts_nested_attributes_for :answers, allow_destroy: true

  #Kaminari
  paginates_per 6
end
