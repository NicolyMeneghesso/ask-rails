class Api::ChartsController < ApplicationController
  def top_subjects
    # Exemplo: contar quantas respostas cada assunto recebeu
    top_subjects = Subject
      .select("subjects.description, COUNT(user_question_answers.id) AS answers_count") # seleciona o nome do assunto e faz a contagem
      .joins(questions: :user_question_answers) # conecta os assuntos até as respostas dos usuários.
      .group("subjects.id", "subjects.description") # Agrupamos por subjects.id para que o COUNT(answers.id) funcione corretamente.
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

  def user_graph_answers
    users_answers = UserStatistic.where(user: current_user)

    question_right = users_answers.sum(:right_questions)
    question_wrong = users_answers.sum(:wrong_questions)

    questions_site = Question.count

    total_user = question_right + question_wrong

    render json: { right: question_right, wrong: question_wrong, questionSite: questions_site, questionUser: total_user }
  end
end
