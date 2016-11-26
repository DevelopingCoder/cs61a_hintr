require 'spec_helper'

RSpec.describe "UploadT2C" do
    before (:each) do
        @user = FactoryGirl.create(:admin)
        
        #Create the intial tag2concepts for the db
        tag1 = Tag.create!({:name => "test_tag 1", :description => "irrelephant", :example => "example"})
        tag2 = Tag.create!({:name => "test_tag 2", :description => "irrelephant", :example => "example_2"})
        concept1 = Concept.create!({:name => "test_concept 1", :description => "irrelevant"})
        concept2 = Concept.create!({:name => "test_concept 2", :description => "irrelevant"})
        tag1.concepts << concept1
        tag1.concepts << concept2
        tag2.concepts << concept1
        tag2.concepts << concept2
        
        tag3 = Tag.create!({:name => "test_tag 3", :description => "irrelephant", :example => "example"})
        tag4 = Tag.create!({:name => "test_tag 4", :description => "irrelephant", :example => "example_2"})
        concept3 = Concept.create!({:name => "test_concept 3", :description => "irrelevant"})
        concept4 = Concept.create!({:name => "test_concept 4", :description => "irrelevant"})
        
        tag5 = Tag.create!({:name => "test_tag 5", :description => "irrelephant", :example => "example"})
        tag6 = Tag.create!({:name => "test_tag 6", :description => "irrelephant", :example => "example_2"})
        concept5 = Concept.create!({:name => "test_concept 5", :description => "irrelevant"})
        concept6 = Concept.create!({:name => "test_concept 6", :description => "irrelevant"})
        tag5.concepts << concept5
        tag5.concepts << concept6
        tag6.concepts << concept5
        tag6.concepts << concept6
        
        # open the tag2concepts.csv file
        @file = 'spec/upload_files/tag2concepts.csv'
    end
    describe '.import tag2concepts' do
        before (:each) do
            # Call import tag2concepts to get @changes, which is a hash 
            # that keys: additions, deletions, and edits
            @changes = Tag2concept.import(@file)
            @additions = @changes[:additions]
            @deletions = @changes[:deletions]
        end
        it 'returns the additions' do
            expect(@additions.length).to equal(4)
        end
        it 'returns the deletions' do
            expect(@deletions.length).to equal(4)
        end
        it 'doesnt create the objects'  do
            @additions.each do |addition|
                tag = Tag.find_by_name(addition[:tag_name])
                concept = Concept.find_by_name(addition[:concept_name])
                tag2concept_exists = Tag2concept.find_by(:tag_id => tag.id,:concept_id => concept.id)
                expect(tag2concept_exists).to be_falsey
            end
            
            @deletions.each do |deletion|
                tag2concept_exists = Tag2concept.find_by(deletion)
                expect(tag2concept_exists).to be_truthy
            end
        end
    end
    
    describe '.save tag2concept changes' do
        before (:each) do
            #Call import tag2concepts
            #Save those changes
            @changes = Tag2concept.import(@file)
            @additions = @changes[:additions]
            @deletions = @changes[:deletions]
            Tag2concept.save_changes(@changes)
        end
        it 'saves the additions' do
            @additions.each do |addition|
                tag = Tag.find_by_name(addition[:tag_name])
                concept = Concept.find_by_name(addition[:concept_name])
                tag2concept_exists = Tag2concept.find_by(:tag_id => tag.id,:concept_id => concept.id)
                expect(tag2concept_exists).to be_truthy
            end
        end
        it 'saves the deletions' do
            @deletions.each do |deletion|
                tag2concept_exists = Tag2concept.find_by(deletion)
                expect(tag2concept_exists).to be_falsey
            end
        end
    end
end
