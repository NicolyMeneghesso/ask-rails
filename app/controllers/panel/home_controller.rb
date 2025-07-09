class Panel::HomeController < PanelBaseController
  def index
    @user_statistic = UserStatistic.find_or_create_by(user: current_user)
    @total_questions_count = Question.count # ira mostrar o número total de perguntas cadastradas no banco de dados.

    set_admin_data unless current_user.regular?
  end

  private

  def set_admin_data
    # total de assuntos para o card
    @total_subjects = Subject.count

    # Agrupa por tipo de usuário (inteiros)
    @user_counts = User.group(:user_type).count

    # 2. Pegamos todos os IDs de usuários comuns (user_type: 0)
    user_ids = User.regular.pluck(:id)

    # 3. Total de usuários comuns
    @users_can_answer_count = user_ids.size

    # 4. UserStatistics desses usuários
    @users_can_answer = UserStatistic.where(user_id: user_ids)

    # 5. Somamos respostas corretas e erradas
    @total_users_statistic_right = @users_can_answer.sum(:right_questions)
    @total_users_statistic_wrong = @users_can_answer.sum(:wrong_questions)
    @total_answers = @total_users_statistic_right + @total_users_statistic_wrong

    # 6. Filtramos os que realmente responderam algo
    @users_who_answered = @users_can_answer.where("right_questions > 0 OR wrong_questions > 0").count
  end
end
