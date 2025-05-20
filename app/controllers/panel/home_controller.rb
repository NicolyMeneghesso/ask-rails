class Panel::HomeController < PanelBaseController
  def index
    @user_statistic = UserStatistic.find_or_create_by(user: current_user)
    @total_questions_count = Question.count # conterá o número total de perguntas cadastradas no banco de dados.
  end
end
