class AddUserIdToAnswers < ActiveRecord::Migration[8.0]
  def change
    add_column :answers, :user_id, :integer
  end
end
