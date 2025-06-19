class Question < ApplicationRecord
  belongs_to :subject, counter_cache: true
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true
  has_many :user_question_answers

  # Kaminari
  paginates_per 6
end
