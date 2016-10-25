require 'spec_helper'

RSpec.describe PagesController, type: :controller do
    describe ".add_users" do
        it "doesn't allow because you're not admin" do
            user = FactoryGirl.create(:user)
            sign_in(user)
            post :add_user, {:add_email => "testuser2@gmail.com"}
            expect(response.body).to include "You do not have the permissions to add a users"
        end
        
        it "calls invite method in model" do
            admin = FactoryGirl.create(:admin)
            sign_in(admin)
            post :add_user, {:add_email => "testuser@gmail.com"}
            expect(User).to receive(:add_user).with("testuser@gmail.com")
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil
        end
    end
    
    describe ".delete_user" do
        it "doesn't allow because you're not admin" do
            user = FactoryGirl.create(:user)
            sign_in(user)
            put :delete_user, {:delete_email => "testuser2@gmail.com"}
            expect(response.body).to include "You do not have the permissions to delete users" 
            
        end
        it "calls delete method in model" do
            admin = FactoryGirl.create(:admin)
            sign_in(admin)
            FactoryGirl.create(:user, email: "testuser@gmail.com")
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil    
            put :delete_user, {:delete_email => "testuser@gmail.com"}
            expect(User).to receive(:delete_user).with("testuser@gmail.com")
            expect(User.find_by_email("testuser@gmail.com")).to be_nil
        end
    end
end