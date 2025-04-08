class PanelBaseController < ApplicationController
    before_action :authenticate_user!
    layout "panel"

  private
    def permitted_user_params
      # é um array contendo os campos que podem ser alterados no formulário
      permitted_params = [ :username, :address, :email, :password, :password_confirmation ]
      permitted_params << :user_type if current_user.user_type == 2 # Apenas Super Admins podem editar

      params.require(:user).permit(permitted_params)
    end

    def verify_password
      # Remove os campos de senha e confirmação dos parâmetros se ambos estiverem em branco
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].extract!(:password, :password_confirmation)
      end
    end

    def authorize_admin_access
      unless [ 1, 2 ].include?(current_user.user_type)
        redirect_to panel_home_index_path
      end
    end

    def verify_params_questions
      params_questions = [ :description, :subject_id ]
      params_questions << :user_type if current_user.user_type.in?([ 1, 2 ])
      params.require(:question).permit(params_questions)
    end

    def verify_params_subjects
      params_subjects = [ :description, :subject_id ]
      params_subjects << :user_type if current_user.user_type.in?([ 1, 2 ])
      params.require(:subject).permit(params_subjects)
    end
end
