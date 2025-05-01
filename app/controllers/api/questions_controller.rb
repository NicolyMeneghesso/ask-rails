class Api::QuestionsController < ApplicationController
  # Retorna todas as questões filtradas pelo subject_id em formato JSON
  def index
    questions = Question.where(subject_id: params[:subject_id])
    render json: questions.to_json
  end

  def answers
    if params[:question_id].blank?
      render json: { error: "Parâmetro question_id ausente" }, status: :bad_request
      return
    end

    answers = Answer.where(question_id: params[:question_id])
    render json: answers
  end

  def answer_check
    if params[:answer_id].blank?
      return render json: { error: "Parâmetro answer_id ausente" }, status: :bad_request
    end

    answer_response = Answer.find(params[:answer_id])&.correct || false
    render json: { correct: answer_response }
  end
end
