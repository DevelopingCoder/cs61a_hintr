require 'spec_helper'

describe User do
    before :each do
        @user = FactoryGirl.create(:admin)
    end
    describe 'add email' do
        it 'takes an email and creates a user' do
            expect(@user.add_email("testuser@gmail.com")).to eq "Email invite has been sent"
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil
        end
        it 'complains if email is already in db' do
            User.create({:email => "testuser@gmail.com", :password => "password"})
            expect(@user.add_email("testuser@gmail.com")).to eq "Email already exists in database"
        end
    end
    
    describe 'delete email' do
        it 'complains if you delete yourself' do
            expect(@user.delete_email("testadmin@gmail.com")).to eq "User cannot delete self"
        end
        it 'takes an email and deletes account' do
            User.create({:email => "testuser@gmail.com", :password => "password"})
            expect(@user.delete_email("testuser@gmail.com")).to eq "User successfully deleted"
            expect(User.find_by_email("testuser@gmail.com")).to be_nil
        end
        it 'complains if email is not in db' do
            expect(@user.delete_email("asdf@asdf.com")).to eq "User never existed"
        end
    end
    
    describe 'toggle admin' do
        it "takes an id of a user and changes that user's admin privileges to be status" do
            user = FactoryGirl.create(:admin, email: "test@gmail.com")
            expect(@user.toggle_admin(user.id, false)).to eq "Toggle successful"
            expect(User.find(user.id).admin?).to eq false 
        end
        it "takes invalid id and responds" do
            expect(@user.toggle_admin(23432, false)).to eq "Invalid id"
        end
        it "takes an id of self and complains that you can't change admin privileges of self" do
            expect(@user.toggle_admin(@user.id, false)).to eq "Cannot unadmin yourself"
            expect(@user.admin?).to eq true
        end
    end
end