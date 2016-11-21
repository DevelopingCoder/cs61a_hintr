class UsersController < ApplicationController
    skip_before_action :authenticate_user, only: [:forgot_password]

    def create
        if current_user.admin?
            email = params[:add_email]
            name = params[:add_name]
            flash[:notice] = current_user.add_email(email, name)
        else
            flash[:notice] = "You do not have the permissions to add a user"
        end
        redirect_to display_users_path
    end
    
    def forgot_password
        email = params[:email]
        user = User.find_by_email(email)
        if not user
            flash[:notice] = "User does not exist"
        else
            flash[:notice] = "An email with a temporary password has been sent"
        end
        password = SecureRandom.urlsafe_base64(6)
        user.password = password
        user.save!
        User.send_email(email, password)
        redirect_to root_path
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