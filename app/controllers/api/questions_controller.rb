class Api::QuestionsController < ApplicationController
  # Retorna todas as questões filtradas pelo subject_id em formato JSON
  def index
    questions = Question.where(subject_id: params[:subject_id])
    render json: questions.to_json
  end

  # Retorna todas as respostas (alternativas) de uma pergunta específica (question_id), no formato JSON
  def answers
    if params[:question_id].blank?
      render json: { error: "Parâmetro question_id ausente" }, status: :bad_request
      return
    end

    answers = Answer.where(question_id: params[:question_id])
    render json: answers
  end

  # Verifica se uma resposta enviada pelo usuário está correta e atualiza suas estatísticas
  # Espera receber: answer_id
  # Retorna: { correct: true/false }
  def answer_check
    if params[:answer_id].blank? # Valida se o parâmetro foi enviado
      return render json: { error: "Parâmetro answer_id ausente" }, status: :bad_request
    end

    answer = Answer.find(params[:answer_id])  # Busca a resposta com base no ID enviado
    answer_response = answer&.correct || false # Verifica se a resposta está marcada como correta

    #  Registra no banco que o usuário respondeu essa pergunta com essa alternativa
    UserQuestionAnswer.create!(
      user: current_user,
      question: answer.question,
      answer: answer
    )
    # Atualiza as estatísticas do usuário (respostas certas ou erradas)
    set_user_statistic(answer_response)

    # Retorna se a resposta enviada é correta ou não
    render json: { correct: answer_response }
  end

  private
  # Atualiza as estatísticas do usuário com base na resposta enviada.
  def set_user_statistic(answer_response)
    user_statistic = UserStatistic.find_or_create_by(user: current_user) # Procura no banco uma estatística vinculada ao usuário logado
    if answer_response
      user_statistic.increment!(:right_questions)
    else
      user_statistic.increment!(:wrong_questions)
    end
  end
end
