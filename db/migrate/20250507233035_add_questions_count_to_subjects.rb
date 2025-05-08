class AddQuestionsCountToSubjects < ActiveRecord::Migration[8.0]
  def change
    add_column :subjects, :questions_count, :integer
  end
end
