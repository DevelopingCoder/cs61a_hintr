require 'spec_helper'

#use subject.current_user for devise
RSpec.describe UploadsController, type: :controller do
    before(:each) do
        user = FactoryGirl.create(:user, email: "testuser@gmail.com")
        sign_in(user)
        @file = File.open('upload_files/concepts.csv')
    end
    
    describe ".upload a concepts file" do
        #http://stackoverflow.com/questions/7260394/test-a-file-upload-using-rspec-rails
        it "calls the import function in Concepts" do
            expect(Concept).to receive(:import) 
            post upload_path, :concepts_file => @file #Doesn't really matter
        end
        it "redirects to the confirmation page" do
            post upload_path, :concepts_file => @file
            expect(response).to redirect_to('upload/confirmation')
        end
    end
    
    describe ".confirming the changes for the concepts file", type: :controller do
        it "calls the save_changes function in Concepts" do
            post upload_path, :concepts_file => @file #Doesn't matter
            expect(Concept).to receive(:save_changes)
            post 'upload/confirmation'
        end
    end
    
end