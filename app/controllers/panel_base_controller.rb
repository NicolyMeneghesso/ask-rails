class PanelBaseController < ApplicationController
    before_action :authenticate_user!
    layout 'panel'
end
