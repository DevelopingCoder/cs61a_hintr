require 'spec_helper'

RSpec.describe "UploadTags" do
    before (:each) do
        @user = FactoryGirl.create(:admin)
        
        #Create the intial tags for the db
        Tag.create!({:name => "test_tag 1", :description => "test_description_1", :example => "example"})
        Tag.create!({:name => "test_tag 2", :description => "test_description_2", :example => "example_2"})
        Tag.create!({:name => "test_tag 3", :description => "test_description_3", :example => "example_3"})
        Tag.create!({:name => "test_tag 4", :description => "test_description_4", :example => "example_4"})
        Tag.create!({:name => "test_tag deletion", :description => "delete", :example => "example"})
        # open the tags.csv file
        @file = 'spec/upload_files/tags.csv'
    end
    describe '.import tags' do
        before (:each) do
            # Call import tags to get @changes, which is a hash 
            # that keys: additions, deletions, and edits
            @changes = Tag.import(@file)
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
            expect(@edits.length).to equal(3)
        end
        it 'doesnt create the objects'  do
            @additions.each do |addition|
                tag_exists = Tag.find_by_name(addition[:name])
                expect(tag_exists).to be_falsey
            end
            
            @deletions.each do |deletion|
                tag_exists = Tag.find_by_name(deletion[:name])
                expect(tag_exists).to be_truthy
            end
            
            @edits.each do |edit|
                orig = Tag.find_by_name(edit[:name])
                same_desc = orig[:description] == edit[:description]
                same_example = orig[:example] == edit[:example]
                #We know at least one has changed
                expect(same_example && same_desc).to be false  
            end
        end
    end
    
    describe '.save tag changes' do
        before (:each) do
            #Call import tags
            #Save those changes
            @changes = Tag.import(@file)
            @additions = @changes[:additions]
            @deletions = @changes[:deletions]
            @edits = @changes[:edits]
            Tag.save_changes(@changes)
        end
        it 'saves the additions' do
            @additions.each do |addition|
                tag_exists = Tag.find_by_name(addition[:name])
                expect(tag_exists).to be_truthy
            end
        end
        it 'saves the deletions' do
            @deletions.each do |deletion|
                tag_exists = Tag.find_by_name(deletion[:name])
                expect(tag_exists).to be_falsey
            end
        end
        
        #Description must change
        it 'saves the edits' do
            @edits.each do |edit|
                orig = Tag.find_by_name(edit[:name])
                same_desc = orig[:description] == edit[:description]
                same_example = orig[:example] == edit[:example]
                expect(same_desc || same_example).to be true
            end
        end
    end
    describe "destroying tags" do
        before (:each) do
            concept = Concept.create({:name => "test_concept 1", :description => "irrelephant"})
            Tag.find_by_name("test_tag 1").concepts << concept
        end
        it "destroys tag2concepts associated with them" do
            concept = Concept.find_by_name("test_concept 1")
            tag = Tag.find_by_name("test_tag 1")
            concept_id = concept.id
            expect(Tag2concept.find_by({:tag_id => tag.id,:concept_id => concept_id})).to be_truthy
            concept.destroy
            expect(Tag2concept.find_by({:tag_id => tag.id,:concept_id => concept_id})).to be_falsey
        end
    end
    describe 'import corrupt tag.csv with tag that doesnt exist' do
        it 'lets you know if tag name is missing' do
            expect(Tag.verify_row(nil, "", "")).to eq "Tag name doesn't exist for one of 'em. Upload aborted"
        end
        it 'lets you know if tag description is missing' do
            expect(Tag.verify_row("", nil, "")).to eq "Tag description doesn't exist for one of 'em. Upload aborted"
        end
        it 'lets you know if tag example is missing' do
            expect(Tag.verify_row("", "", nil)).to eq "Tag example doesn't exist for one of 'em. Upload aborted"
        end
    end
end