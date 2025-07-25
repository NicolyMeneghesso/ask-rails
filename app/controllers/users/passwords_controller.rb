# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
  #
  def create # Sobrescreve o método `create` padrão do Devise para envio de instruções de redefinição de senha.
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    # Em vez de redirecionar, renderiza novamente a página `new` com uma flash message
    if successfully_sent?(resource)
      flash.now[:notice] = I18n.t("devise.passwords.send_instructions")
      render :new
    else
      render :new
    end
  end
end
