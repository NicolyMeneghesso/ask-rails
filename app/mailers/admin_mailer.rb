class AdminMailer < ApplicationMailer
  def update_email(current_user, user)
    @current_user = current_user # quem fez a alteração
    @user = user # quem teve os dados alterados

    mail(to: @user.email, subject: "Seus dados foram alterados!")
  end

  def new_user_email (current_user, user)
    @current_user = current_user
    @user = user

    mail(to: @user.email, subject: "Seu cadastro foi realizado")
  end
end
