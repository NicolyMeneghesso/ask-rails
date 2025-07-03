class PanelBaseController < ApplicationController
    before_action :authenticate_user!
    layout "panel"

  private
    # Permite acesso apenas a Super Admins (user_type == 2)
    def authorize_super_admin!
      unless current_user.user_type == 2
        flash[:alert] = "Apenas o Administrador Geral podem acessar esta página."
        redirect_to panel_home_index_path
      end
    end

    # Permite acesso ao próprio usuário ou ao Super Admin
    def authorize_self_or_super_admin!(target_user)
      unless current_user == target_user || current_user.user_type == 2
        flash[:alert] = "Você não tem permissão para acessar esta página."
        redirect_to panel_home_index_path
      end
    end

    # Permite acesso apenas ao próprio usuário
    def only_self!(target_user)
      unless current_user == target_user
        flash[:alert] = "Você só pode acessar seu próprio perfil."
        redirect_to panel_home_index_path
      end
    end

    # Este método define os campos permitidos no formulário de criação/edição de usuário.
    def permitted_user_params
      permitted_params = [ :first_name, :last_name, :address_street, :address_building_number, :address_city, :address_state,
                            :address_country, :email, :password, :password_confirmation ]
      permitted_params << :user_type if current_user.user_type == 2 # Adiciona o campo :user_type apenas se o usuário atual for Super Admin (user_type == 2).

      # Garante que os parâmetros recebidos vêm de params[:user] e filtra apenas os campos permitidos
      params.require(:user).permit(permitted_params)
    end

    # Remove os campos de senha se estiverem em branco (evita sobrescrever com vazio)
    def verify_password
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].extract!(:password, :password_confirmation)
      end
    end

    # Restringe acesso à área administrativa apenas para Admins e Super Admins
    def authorize_admin_access
      unless [ 1, 2 ].include?(current_user.user_type)
        redirect_to panel_home_index_path
      end
    end
end
