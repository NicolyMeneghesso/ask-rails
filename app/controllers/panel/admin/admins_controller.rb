class Panel::Admin::AdminsController < PanelBaseController
  before_action :authorize_super_admin!

  def index
    @admins = User.where(user_type: [ 1, 2 ]).page(params[:page])
  end
end
