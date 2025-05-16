class UserStatistic < ApplicationRecord
  belongs_to :user

  # Virtual Attributes que retorna o total de questões respondidas
  def total_questions
    self.right_questions + self.wrong_questions
  end
end
