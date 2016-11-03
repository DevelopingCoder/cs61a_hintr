class UsersController < ApplicationController
    before_action :authenticate_user!
    
    def create
        if current_user.admin?
            email = params[:add_email]
            flash[:notice] = current_user.add_email(email)
        else
            flash[:notice] = "You do not have the permissions to add a user"
        end
        redirect_to display_users_path
    end
    
    def destroy
        if current_user.admin?
            emails = params[:delete_emails]
            if emails
                flash[:notice] = current_user.delete_emails(emails)
            end
        else
            flash[:notice] = "You do not have the permissions to delete users"
        end
        redirect_to display_users_path
    end
    
    def index
        @users = User.all.order("admin DESC")
        # If @users is nil, then log it b/c users should never be nil
        if @users == nil
            logger.fatal "There are no users in the db"
        end
    end
    
    def edit 
        #Used for admin purposes to edit users
        id = params[:id]
        json = JSON.parse(request.body.read)
        if current_user.admin?
            case json["field"]
            when "admin"
                message = current_user.toggle_admin(id, json["value"])
            end
            render :json => message
        end 
    end
end