require 'securerandom'

class PagesController < ApplicationController
    before_action :authenticate_user!
    
    def add_user
        if current_user.admin?
            email = params[:add_email]
<<<<<<< bb18468162551b3dcb332105213c33f504d32753
            # password = generate_password
            password = SecureRandom.urlsafe_base64(6)
=======
            password = generate_password
>>>>>>> Created Cuke tests for Uploading
            name = ''
            #Check if user is already added
            success = User.create({:name=>name, :email => email, :password => password})
            if success.id
                flash[:notice] = "Email invite(s) have been sent"
                success.send_email()
            # else
            #     flash[:notice] = "User creation unsuccessful"
            end
        end
        redirect_to display_users_path
    end
    
    #Add checks to ensure no deletion of admin? No deletion of self?
    def delete_user
        if current_user.admin?
            email = params[:delete_email]
            pop_user = User.find_by_email(email)
            if pop_user
                success = pop_user.destroy
                if success
                    flash[:notice] = "User deletion successful"
                # else
                #     flash[:notice] = "User deletion unsuccessful"
                end
            # else
            #     flash[:notice] = "User with specified email does not exist"
            end
        end
        redirect_to display_users_path
    end
    
    def generate_password
        'password'    
    end
    
    def display_users
        @users = User.all
        # If @users is nil, then log it b/c users should never be nil
    end

end