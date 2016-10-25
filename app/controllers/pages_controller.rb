class PagesController < ApplicationController
    before_action :require_login
    def require_login
        if not (user_signed_in?)
            redirect_to new_user_session_path # halts request cycle
        end
    end
end
