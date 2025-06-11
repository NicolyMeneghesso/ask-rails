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

    # 1. Pega todos os UserStatistic de usuários com user_type: 0 (usuários comuns) - sendo um ActiveRecord::Relation
    @users_can_answer = UserStatistic.where(user_id: User.where(user_type: 0).select(:id))

    # total de respostas corretas + erradas feitas por usuários comuns
    @total_users_statistic_right = @users_can_answer.sum(:right_questions)
    @total_users_statistic_wrong = @users_can_answer.sum(:wrong_questions)
    @total_answers = @total_users_statistic_right + @total_users_statistic_wrong

    # 2. Filtra os que realmente responderam alguma pergunta (acertando ou errando)
    @users_who_answered = @users_can_answer.where("right_questions > 0 OR wrong_questions > 0").count

    load_top_subjects
  end

  def load_top_subjects
  # Exemplo: contar quantas respostas cada assunto recebeu
  @top_subjects = Subject
    .select("subjects.description, COUNT(answers.id) AS answers_count") # seleciona o nome do assunto e faz a contagem
    .joins(questions: :answers) # ligando as tabelas de assuntos, perguntas e respostas numa consulta só.
    .group("subjects.id") # Agrupamos por subjects.id para que o COUNT(answers.id) funcione corretamente.
    .order("answers_count DESC")
    .limit(5) # mostra os 5 mais respondidos
  end
end
