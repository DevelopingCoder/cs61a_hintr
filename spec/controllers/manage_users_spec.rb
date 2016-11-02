require 'spec_helper'

#use subject.current_user for devise
RSpec.describe UsersController, type: :controller do
    describe ".add_users" do
        it "doesn't allow because you're not admin" do
            user = FactoryGirl.create(:user)
            sign_in(user)
            post :create, {:add_email => "testuser2@gmail.com"}
            expect(response).to redirect_to(display_users_path)
            get :index
            expect(response.body).to include "You do not have the permissions to add a user"
        end
        
        it "calls invite method in model" do
            admin = FactoryGirl.create(:admin)
            sign_in(admin)
            expect_any_instance_of(User).to receive(:add_email).with("testuser@gmail.com")
            post :create, {:add_email => "testuser@gmail.com"}
        end
    end
    
    describe ".delete_user" do
        it "doesn't allow because you're not admin" do
            user = FactoryGirl.create(:user)
            sign_in(user)
            put :destroy, {:delete_email => "testuser2@gmail.com"}
            get :index
            expect(response.body).to include "You do not have the permissions to delete users" 
            
        end
        it "calls delete method in model" do
            admin = FactoryGirl.create(:admin)
            sign_in(admin)
            FactoryGirl.create(:user, email: "testuser@gmail.com")
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
end