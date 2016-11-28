require 'spec_helper'

RSpec.describe "UploadConcepts" do
    before (:each) do
        @user = FactoryGirl.create(:admin)
        
        #Create the intial concepts for the db
        Concept.create!({:name => "test_concept 1", :description => "test_concept_description"})
        Concept.create!({:name => "test_concept 2", :description => "test_concept_description2"})
        Concept.create!({:name => "test_concept 3", :description => "test_concept_description3"})
        Concept.create!({:name => "test_concept 4", :description => "test_concept_description4"})
        
        # open the concepts.csv file
        @file = 'spec/upload_files/concepts.csv'
    end
    describe '.import concepts' do
        before (:each) do
            # Call import concepts to get @changes, which is a hash 
            # that keys: additions, deletions, and edits
            @changes = Concept.import(@file)
            @additions = @changes[:additions]
            @deletions = @changes[:deletions]
            @edits = @changes[:edits]
        end
        it 'returns the additions' do
            expect(@additions.length).to equal(1)
        end
        it 'returns the deletions' do
            expect(@deletions.length).to equal(1)
        end
        it 'returns the edits' do
            expect(@edits.length).to equal(2)
        end
        it 'doesnt create the objects'  do
            @additions.each do |addition, message|
                concept_exists = Concept.find_by_name(addition[:name])
                expect(concept_exists).to be_falsey
                
                message_exists = Message.find_by_content(message)
                expect(message_exists).to be_falsey
            end
            
            @deletions.each do |deletion|
                concept_exists = Concept.find_by_name(deletion[:name])
                expect(concept_exists).to be_truthy
            end
            
            @edits.each do |edit, message| #message is a string, may be empty
                if message.length > 0
                    message_exists = Message.find_by_content(message) 
                    expect(message_exists).to be_falsey
                else
                    orig = Concept.find_by_name(edit[:name])
                    same_desc = orig[:description] == edit[:description] 
                    expect(same_desc).to be false
                end
            end
        end
    end

    describe '.save concept changes' do
        before (:each) do
            #Call import concepts
            #Save those changes
            @changes = Concept.import(@file)
            @additions = @changes[:additions]
            @deletions = @changes[:deletions]
            @edits = @changes[:edits]
            Concept.save_changes(@changes)
        end
        it 'saves the additions' do
            @additions.each do |addition, message|
                concept_exists = Concept.find_by_name(addition[:name])
                expect(concept_exists).to be_truthy
                
                message_exists = Message.find_by_content(message)
                expect(message_exists).to be_truthy
            end
        end
        it 'saves the deletions' do
            @deletions.each do |deletion|
                concept_exists = Concept.find_by_name(deletion[:name])
                expect(concept_exists).to be_falsey
            end
        end
        
        #Description must change or message must be created
        it 'saves the edits' do
            @edits.each do |edit, message| #message is a string, may be empty
                if message.length > 0
                    message_exists = Message.find_by_content(message) 
                    expect(message_exists).to be_truthy
                else
                    orig = Concept.find_by_name(edit[:name])
                    same_desc = orig[:description] == edit[:description] 
                    expect(same_desc).to be true
                end
            end
        end
    end
    
    describe "destroying tags" do
        before (:each) do
            tag = Tag.create({:name => "test_tag 1", :description => "irrelephant", :example => "example"})
            Concept.find_by_name("test_concept 1").tags << tag
        end
        it "destroys tag2concepts associated with them" do
            concept = Concept.find_by_name("test_concept 1")
            tag = Tag.find_by_name("test_tag 1")
            tag_id = tag.id
            expect(Tag2concept.find_by({:tag_id => tag_id,:concept_id => concept.id})).to be_truthy
            tag.destroy
            expect(Tag2concept.find_by({:tag_id => tag_id,:concept_id => concept.id})).to be_falsey
        end
    end
    
    describe 'import corrupt concepts.csv with missing fields' do
        it 'lets you know if concept name is missing' do
            expect(Concept.verify_row(" ", "d")).to eq "Concept name for one of the concepts is missing. Upload aborted"
        end
        it 'lets you know if concept description is missing' do
            expect(Concept.verify_row("asdf", "   ")).to eq "Concept description for one of the concepts is missing. Upload aborted"
        end
    end
end