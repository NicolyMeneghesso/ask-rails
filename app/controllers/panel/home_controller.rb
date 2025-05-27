class Panel::HomeController < PanelBaseController
  def index
    @user_statistic = UserStatistic.find_or_create_by(user: current_user)
    @total_questions_count = Question.count # ira mostrar o número total de perguntas cadastradas no banco de dados.

    set_admin_data unless current_user.user_type == 0
  end

  private

  def set_admin_data
    # total de usuarios para o card
    @user_counts = User.group(:user_type).count
    # total de assuntos para o card
    @total_subjects = Subject.count

    # mostra o total de perguntas respondidas
    @total_users_statistic_right = UserStatistic.sum(:right_questions)
    @total_users_statistic_wrong = UserStatistic.sum(:wrong_questions)
    @total_answers = @total_users_statistic_right + @total_users_statistic_wrong

    # 1. Pega todos os UserStatistic de usuários com user_type: 0 (usuários comuns)
    @users_can_answer = UserStatistic.where(user_id: User.where(user_type: 0).select(:id))

    # 2. Filtra os que realmente responderam alguma pergunta (acertando ou errando)
    @users_who_answered = @users_can_answer.where("right_questions > 0 OR wrong_questions > 0").count
  end
end
