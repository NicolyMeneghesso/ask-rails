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
end
