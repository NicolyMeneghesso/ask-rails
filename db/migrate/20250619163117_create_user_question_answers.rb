class CreateUserQuestionAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :user_question_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
