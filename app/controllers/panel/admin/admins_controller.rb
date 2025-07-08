class Panel::Admin::AdminsController < PanelBaseController
  before_action :authorize_super_admin!

  def index
    @admins = User.admins_only.search_by_name(params[:term]).page(params[:page])
  end
end
