class Panel::HomeController < PanelBaseController
  def index
    @user_statistic = UserStatistic.find_or_create_by(user: current_user)
    @total_questions_count = Question.all.size
  end
end
