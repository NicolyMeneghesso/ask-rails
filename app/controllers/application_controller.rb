class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_forgery_protection

  # Isso garante que os métodos do Devise estejam disponíveis
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  # Depois que o usuário fizer login com sucesso, redirecione ele para panel_home_index_path
  def after_sign_in_path_for(resource)
    panel_home_index_path
  end
end
