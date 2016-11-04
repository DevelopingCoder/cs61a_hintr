require 'spec_helper'

describe User do
    before :each do
        @user = FactoryGirl.create(:admin)
    end
    describe 'add email' do
        it 'takes an email and creates a user' do
            expect(@user.add_email("testuser@gmail.com", "Pikachu")).to eq "Email invite has been sent"
            expect(User.find_by_email("testuser@gmail.com")).not_to be_nil
        end
        it 'complains if email is already in db' do
            User.create({:name => "Jigglypuff", :email => "testuser@gmail.com", :password => "password"})
            expect(@user.add_email("testuser@gmail.com", "Magikarp")).to eq "Email already exists in database"
        end
        it 'complains if user creation unsuccessful' do
            expect(@user.add_email("test@gmail.com", nil)).to eq "Something went wrong. You may have performed an invalid action"
        end
    end
    
    describe 'delete email' do
        it 'complains if you delete yourself' do
            expect(@user.delete_email("testadmin@gmail.com")).to eq "User cannot delete self"
        end
        it 'takes an email and deletes account' do
            User.create({:name => "Charmander", :email => "testuser@gmail.com", :password => "password"})
            expect(@user.delete_email("testuser@gmail.com")).to eq "User successfully deleted"
            expect(User.find_by_email("testuser@gmail.com")).to be_nil
        end
        it 'complains if email is not in db' do
            expect(@user.delete_email("asdf@asdf.com")).to eq "Something went wrong. You may have performed an invalid action"
        end
        it 'deletes multiple emails successfully' do
            User.create({:name => "Squirtle", :email => "squirtle@gmail.com", :password => "password"})
            User.create({:name => "Wartortle", :email => "wartortle@gmail.com", :password => "password"})
            User.create({:name => "Blastoise", :email => "blastoise@gmail.com", :password => "password"})
            @user.delete_emails(["squirtle@gmail.com", "wartortle@gmail.com", "blastoise@gmail.com"])
            expect(User.find_by_name("Squirtle")).to be nil
            expect(User.find_by_name("Wartortle")).to be nil
            expect(User.find_by_name("Blastoise")).to be nil            
        end
    end
    
    describe 'toggle admin' do
        it "takes an id of a user and unadmins that user" do
            user = FactoryGirl.create(:admin, email: "test@gmail.com")
            expect(@user.toggle_admin(user.id, false)).to eq "Admin User is no longer an admin. Lol"
            expect(User.find(user.id).admin?).to eq false 
        end
        it "takes an id of a user and admins that user" do
            user = FactoryGirl.create(:user, email: "test@gmail.com")
            expect(@user.toggle_admin(user.id, true)).to eq "Regular User is now an admin"
            expect(User.find(user.id).admin?).to eq true 
        end
        it "takes invalid id and responds" do
            expect(@user.toggle_admin(23432, false)).to eq "Something went wrong. You may have performed an invalid action"
        end
        it "takes an id of self and complains that you can't change admin privileges of self" do
            expect(@user.toggle_admin(@user.id, false)).to eq "Cannot unadmin yourself"
            expect(@user.admin?).to eq true
        end
    end
end