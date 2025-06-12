class Api::ChartsController < ApplicationController
  def top_subjects
    # Exemplo: contar quantas respostas cada assunto recebeu
    top_subjects = Subject
      .select("subjects.description, COUNT(answers.id) AS answers_count") # seleciona o nome do assunto e faz a contagem
      .joins(questions: :answers) # ligando as tabelas de assuntos, perguntas e respostas numa consulta só.
      .group("subjects.id") # Agrupamos por subjects.id para que o COUNT(answers.id) funcione corretamente.
      .order("answers_count DESC")
      .limit(7) # mostra os 5 mais respondidos

      render json: top_subjects.map { |s| { name: s.description, count: s.answers_count.to_i } }
  end

  def active_users
    # 1. Pegamos todos os IDs de usuários comuns (user_type: 0)
    user_ids = User.where(user_type: 0).pluck(:id)

    # 2. Total de usuários comuns
    users_can_answer_count = user_ids.size

    # 3. UserStatistics desses usuários
    users_can_answer = UserStatistic.where(user_id: user_ids)

    # 4. Filtra apenas os que realmente responderam
    users_who_answered = users_can_answer.where("right_questions > 0 OR wrong_questions > 0").count

    users_inactive = users_can_answer_count - users_who_answered

    render json: { active: users_who_answered, inactive: users_inactive }
  end
end
