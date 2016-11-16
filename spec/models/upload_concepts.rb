require 'spec_helper'

describe 'Upload Concepts' do
    before (:all) do
        @user = FactoryGirl.create(:admin)
        #Load the intial concepts into the db
        Concept.import(File.open('upload_files/intial_concepts.csv'))
        # open the concepts.csv file
        @file = File.open('upload_files/concepts.csv')
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
            expect(@additions.length).to equal(2)
        end
        it 'returns the deletions' do
            expect(@deletions.length).to equal(1)
        end
        it 'returns the edits' do
            expect(@edits.length).to equal(2)
        end
        it 'doesnt create the objects'  do
            @additions.each do |addition|
                concept = addition.name
                expect(Concept.find_by_name(concept)).to be_nil
            end
            
            @deletions.each do |deletion|
                concept = deletion.name
                expect(Concept.find_by_name(concept)).to_not be_nil
            end
            
            @edits.each do |edit, message| #message is a string, may be empty
                orig = Concept.find_by_name(edit.name)
                has_changed = orig.description != edit.description 
                message_exists = Message.find_by_content(message) 
                if message_exists and message_exists.concept == orig
                    has_changed = true
                end
                expect(has_changed).to be_false
            end
        end
    end
    
    describe '.save concept changes' do
        before (:all) do
            #Call import concepts
            #Save those changes
            @changes = Concept.import(@file)
            @additions = @changes[:additions]
            @deletions = @changes[:deletions]
            @edits = @changes[:edits]
            Concept.save_changes(@changes)
        end
        it 'saves the additions' do
            @additions.each do |addition|
                concept = addition.name
                expect(Concept.find_by_name(concept)).to_not be_nil
            end
        end
        it 'saves the deletions' do
            @deletions.each do |deletion|
                concept = deletion.name
                expect(Concept.find_by_name(concept)).to be_nil
            end
        end
        
        it 'saves the edits' do
            @edits.each do |edit, message| #message is a string, may be empty
                orig = Concept.find_by_name(edit.name)
                desc_changed = orig.description != edit.description 
                message_exists = Message.find_by_content(message) 
                if message_exists and message_exists.concept == orig
                    message_added = true
                end
                expect(desc_changed or message_added).to be_true
            end
        end
    end
end