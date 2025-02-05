module PanelHelper
    def current_panel_user
        if current_admin.present?
            current_admin
        elsif current_user.present?
            current_user
        end
    end
end
