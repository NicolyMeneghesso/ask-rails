class Api::QuestionsController < ApplicationController
  # Retorna todas as questões filtradas pelo subject_id em formato JSON
  def index   # Retorna todas as questões associadas a um determinado assunto (subject_id), no formato JSON
    questions = Question.where(subject_id: params[:subject_id])
    render json: questions.to_json
  end

  def answers   # Retorna todas as respostas de uma pergunta específica (question_id), no formato JSON
    if params[:question_id].blank?
      render json: { error: "Parâmetro question_id ausente" }, status: :bad_request
      return
    end

    answers = Answer.where(question_id: params[:question_id])
    render json: answers
  end

  def answer_check   # Verifica se a resposta enviada é a correta
    if params[:answer_id].blank?
      return render json: { error: "Parâmetro answer_id ausente" }, status: :bad_request
    end
    # Busca a resposta pelo ID e retorna true/false com base no atributo `correct`
    answer_response = Answer.find(params[:answer_id])&.correct || false
    render json: { correct: answer_response }
  end
end
