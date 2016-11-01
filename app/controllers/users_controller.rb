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
        @users = User.all
        # If @users is nil, then log it b/c users should never be nil
        if @users == nil
            logger.fatal "There are no users in the db"
        end
    end
    
    def edit 
        #Used for admin purposes
        email = request.body.read[:admin_email]
        byebug
        if current_user.admin? and email
            message = toggle_admin()
            respond_to do |format|
                format.json { 
                    render json: {:message => message}
                }
            end
        end 
    end
end