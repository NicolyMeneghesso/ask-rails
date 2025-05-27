class Panel::HomeController < PanelBaseController
  def index
    @user_statistic = UserStatistic.find_or_create_by(user: current_user)
    @total_questions_count = Question.count # ira mostrar o número total de perguntas cadastradas no banco de dados.

    set_admin_data unless current_user.user_type == 0
  end

  private

  def set_admin_data
    @user_counts = User.group(:user_type).count
    @total_subjects = Subject.count

    @total_users_statistic_right = UserStatistic.sum(:right_questions)
    @total_users_statistic_wrong = UserStatistic.sum(:wrong_questions)
    @total_users_statistic = @total_users_statistic_right + @total_users_statistic_wrong
  end
end
