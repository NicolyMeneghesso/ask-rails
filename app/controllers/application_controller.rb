class ApplicationController < ActionController::Base
  before_action :set_locale

  # Apenas navegadores modernos
  allow_browser versions: :modern
  skip_forgery_protection


  def set_locale
    if params[:locale].present?
      cookies[:language] = params[:locale]
    end

    I18n.locale = cookies[:language] || I18n.default_locale
  end
  # Este metodo todos os links criados com link_to, url_for, form_with, etc. mantenham o locale na URL automaticamente.
  def default_url_options
    { locale: I18n.locale }
  end

  protected
  # Depois que o usuário fizer login com sucesso, redirecione ele para panel_home_index_path
  def after_sign_in_path_for(resource)
    panel_home_index_path
  end
end
