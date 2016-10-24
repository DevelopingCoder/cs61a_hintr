require 'spec_helper'

RSpec.describe PagesController, type: :controller do
    describe ".add_users" do
        it "doesn't allow because you're not admin" do
            user = FactoryGirl.create(:user)
            sign_in(user)
<<<<<<< 0f0ddc34bdb145ef6bd8f22a75993a206a7f6514
            post :add_user, {:add_email => "testuser2@gmail.com"}
=======
            post "/display_users", {:add_email => "testuser2@gmail.com"}
>>>>>>> got factory girl to work for creating users and admins, created tdd for add and deleting users, created tdd for users not having same privileges
            expect(response.body).to include "You do not have the permissions to add a users"
        end
        
        it "calls invite method in model" do
            admin = FactoryGirl.create(:admin)
            sign_in(admin)
<<<<<<< 0f0ddc34bdb145ef6bd8f22a75993a206a7f6514
            post :add_user, {:add_email => "testuser@gmail.com"}
            expect(User).to receive(:add_user).with("testuser@gmail.com")
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil
        end
=======
            post "/display_users", {:add_email => "testuser@gmail.com"}
            expect(User).to receive(:add_user).with("testuser@gmail.com")
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil
        end
        it "gives error message for nonsensical inputs" do
            admin = FactoryGirl.create(:admin)
            sign_in(admin)
            post "/display_users", {:add_email => "awvoijwef"}
            expect(response.body).to include "There was an error with the input"
        end       
>>>>>>> got factory girl to work for creating users and admins, created tdd for add and deleting users, created tdd for users not having same privileges
    end
    
    describe ".delete_user" do
        it "doesn't allow because you're not admin" do
            user = FactoryGirl.create(:user)
            sign_in(user)
<<<<<<< 0f0ddc34bdb145ef6bd8f22a75993a206a7f6514
            put :delete_user, {:delete_email => "testuser2@gmail.com"}
=======
            put "/display_users", {:delete_email => "testuser2@gmail.com"}
>>>>>>> got factory girl to work for creating users and admins, created tdd for add and deleting users, created tdd for users not having same privileges
            expect(response.body).to include "You do not have the permissions to delete users" 
            
        end
        it "calls delete method in model" do
            admin = FactoryGirl.create(:admin)
            sign_in(admin)
            FactoryGirl.create(:user, email: "testuser@gmail.com")
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil    
<<<<<<< 0f0ddc34bdb145ef6bd8f22a75993a206a7f6514
            put :delete_user, {:delete_email => "testuser@gmail.com"}
            expect(User).to receive(:delete_user).with("testuser@gmail.com")
            expect(User.find_by_email("testuser@gmail.com")).to be_nil
        end
=======
            put "/display_users", {:delete_email => "testuser@gmail.com"}
            expect(User).to receive(:delete_user).with("testuser@gmail.com")
            expect(User.find_by_email("testuser@gmail.com")).to be_nil
        end
        it "gives error message for nonsensical inputs" do
            admin = FactoryGirl.create(:admin)
            sign_in(admin)
            put "/display_users", {:delete_email => "awvoijwef"}
            expect(response.body).to include "There was an error with the input"
        end
>>>>>>> got factory girl to work for creating users and admins, created tdd for add and deleting users, created tdd for users not having same privileges
    end
end