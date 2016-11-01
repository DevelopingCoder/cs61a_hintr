require 'spec_helper'

describe User do
    before :each do
        @user = FactoryGirl.create(:admin)
    end
    describe 'add email' do
        it 'takes an email and creates a user' do
            expect(@user.add_email("testuser@gmail.com")).to eq "Email invite have been sent"
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil
        end
        it 'complains if email is already in db' do
            user = User.create({:email => "testuser@gmail.com", :password => "password"})
            expect(@user.add_email("testuser@gmail.com")).to eq "Email already exists in database"
        end
    end
    
    describe 'delete email' do
        it 'complains if you delete yourself' do
            expect(@user.delete_email("testadmin@gmail.com")).to eq "User cannot delete self"
        end
        it 'takes an email and deletes account' do
            user = User.create({:email => "testuser@gmail.com", :password => "password"})
            expect(@user.delete_email("testuser@gmail.com")).to eq "User successfully destroyed"
            expect(User.find_by_email("testuser@gmail.com")).to be_nil
        end
        it 'complains if email is not in db' do
            expect(@user.delete_email("asdf@asdf.com")).to eq "User never existed"
        end
    end
end