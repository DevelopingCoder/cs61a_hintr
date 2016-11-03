require 'spec_helper'

<<<<<<< HEAD
#use subject.current_user for devise
RSpec.describe UsersController, type: :controller do
=======
RSpec.describe PagesController, type: :controller do
>>>>>>> message-voting
    describe ".add_users" do
        it "doesn't allow because you're not admin" do
            user = FactoryGirl.create(:user)
            sign_in(user)
<<<<<<< HEAD
            post :create, {:add_email => "testuser2@gmail.com"}
            expect(response).to redirect_to(display_users_path)
            get :index
            expect(response.body).to include "You do not have the permissions to add a user"
=======
            post :add_user, {:add_email => "testuser2@gmail.com"}
            expect(response.body).to include "You do not have the permissions to add a users"
>>>>>>> message-voting
        end
        
        it "calls invite method in model" do
            admin = FactoryGirl.create(:admin)
            sign_in(admin)
<<<<<<< HEAD
            expect_any_instance_of(User).to receive(:add_email).with("testuser@gmail.com")
            post :create, {:add_email => "testuser@gmail.com"}
=======
            post :add_user, {:add_email => "testuser@gmail.com"}
            expect(User).to receive(:add_user).with("testuser@gmail.com")
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil
>>>>>>> message-voting
        end
    end
    
    describe ".delete_user" do
        it "doesn't allow because you're not admin" do
            user = FactoryGirl.create(:user)
            sign_in(user)
<<<<<<< HEAD
            put :destroy, {:delete_email => "testuser2@gmail.com"}
            get :index
=======
            put :delete_user, {:delete_email => "testuser2@gmail.com"}
>>>>>>> message-voting
            expect(response.body).to include "You do not have the permissions to delete users" 
            
        end
        it "calls delete method in model" do
            admin = FactoryGirl.create(:admin)
            sign_in(admin)
            FactoryGirl.create(:user, email: "testuser@gmail.com")
<<<<<<< HEAD
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil  
            expect_any_instance_of(User).to receive(:delete_email).with("testuser@gmail.com")
            put :destroy, {:delete_email => "testuser@gmail.com"}
        end
    end
    
    # describe ".edit_user" do
    #     it "takes in request.body and id param and edits the field in the body of the id" do
    #         user = FactoryGirl.create(:user, email: "testuser@gmail.com")
    #         params = {"{\"field\":\"admin\",\"value\":false}"=>nil, "id"=>user.id}
    #         expect_any_instance_of(User).to receive(:toggle_admin)
    #         post :edit, params.to_json
    #     end
    # end
=======
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil    
            put :delete_user, {:delete_email => "testuser@gmail.com"}
            expect(User).to receive(:delete_user).with("testuser@gmail.com")
            expect(User.find_by_email("testuser@gmail.com")).to be_nil
        end
    end
>>>>>>> message-voting
end