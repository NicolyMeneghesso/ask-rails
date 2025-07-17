class DeleteQuestionsCountToSubjects < ActiveRecord::Migration[8.0]
  def change
    remove_column :subjects, :questions_count, :integer
  end
end
