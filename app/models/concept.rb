require 'csv'
class Concept < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
    has_many :messages
    has_many :tag2concepts
    has_many :tags, :through => :tag2concepts
    include ActiveModel::Serialization
    
    def attributes
        {:name => name, :description => description}    
    end
    
    def self.verify_first_line(first_line)
        #Check format: concept, description, message
        if first_line.length < 3
          return false
        end
        concept_matches = first_line[0].include?("Concept")
        desc_matches = first_line[1].include?("Description")
        message_matches = first_line[2].include?("Message")
        return concept_matches && desc_matches && message_matches
    end
  
    def self.import(csv_path)
        rows = CSV.read(csv_path)
        if not self.verify_first_line(rows[0])
            return false
        end
        rows.shift

        file_concepts = {}
        rows.each do |row|
            concept_name, description, message = row.map{|n| n.strip if n}
            if not message
                message = ""
            end
            file_concepts[concept_name] = [description, message]
        end
    
        return cross_check_diffs(file_concepts)
    end
    
    def self.make_edit(exist_concept, upload_concept)
        #Check if there's an edit. If so, change it but don't save
        #Otherwise return False
        new_description, new_message = upload_concept
        edit = [exist_concept, ""]
        change_discovered = false
        #Check if description changed
        if exist_concept.description != new_description
            exist_concept.description = new_description
            change_discovered = true
        end
        
        #Check if message should be added
        if new_message.length > 0
            if exist_concept.messages.find_by_content(new_message) == nil
                #Message doesn't exist
                edit[1] = new_message
                change_discovered = true
            end
        end
        
        #Serialize the existing_concept
        edit[0] = edit[0].serializable_hash
        
        if change_discovered
            return edit
        else
            return false
        end
    end

    def self.cross_check_diffs(file_concepts)
        #Returns a hash of answers, edits, deletions. Answers and edits contains 
        #a message, which may be an empty string if we do not want to create a new message
        #Note the instances are in json form
        edits = []
        additions = []
        deletions = []

        #First check edits and deletions
        Concept.all.each do |exist_concept|
            if file_concepts.key?(exist_concept.name)
                upload_concept = file_concepts[exist_concept.name]
                any_edits = make_edit(exist_concept, upload_concept)
                if any_edits
                    edits += [any_edits]
                end
            else
                deletions += [exist_concept.serializable_hash]
            end
        end
        
        #Check for any additions
        file_concepts.keys.each do |concept|
            #Check if not in concept not in db
            if not Concept.find_by_name(concept)
                desc, new_message = file_concepts[concept]
                new_concept = Concept.new({:name => concept, :description => desc})
                additions += [[new_concept.serializable_hash, new_message]]
            end
        end
        return {:additions => additions, :deletions => deletions, :edits => edits}
    end
    
    def self.save_changes(changes)
        additions = changes[:additions]
        deletions = changes[:deletions]
        edits = changes[:edits]
        additions.each do |addition, message|
            concept = Concept.create(addition)
            Message.create(:concept_id => concept.id, :content => message)
        end
        
        deletions.each do |deletion|
            Concept.find_by_name(deletion[:name]).destroy
        end
        
        edits.each do |edit, message|
            concept = Concept.find_by_name(edit[:name])
            concept.update(edit)
            Message.create(:concept_id => concept.id, :content => message)
        end
    end
    
    def update_status
        if self.messages.length == 0
           self.update_attribute(:msg_status, "no messages")
        elsif self.messages.where(:finalized => true).exists?
            self.update_attribute(:msg_status, "assigned")
        else
            self.update_attribute(:msg_status, "in progress")
        end
    end
    
    def assigned_message
        if self.messages and self.messages.where(:finalized => true)
            return self.messages.where(:finalized => true).first
        else
            return nil
        end
    end
    
    def display_tags_string
        display_string = ''
        self.tags.each do |tag|
            display_string += tag.name + ", "
        end
        # remove trailing comma
        return display_string[0...-2]
    end
 
end