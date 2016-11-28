class Tag2concept < ActiveRecord::Base
    validates :tag, presence: true
    validates :concept, presence: true
    belongs_to :tag
    belongs_to :concept
    
    require 'csv'
    include ActiveModel::Serialization
    
    def attributes
        {:tag_id=> tag_id, :concept_id => concept_id}    
    end
    
    def self.verify_first_line(first_line)
        if first_line.length < 2
            return false
        end
        
        verification = []
        verification.append first_line[0].include?("Tag")
        verification.append first_line[1].include?("Concept")
        verification.each do |ver|
            if not ver
                return false
            end
        end
        return true
    end
    
    def self.verify_row(tag_name, concept_name)
        if Tag.find_by_name(tag_name) == nil
            return "One of the tags doesn't exist. Upload aborted"
        elsif Concept.find_by_name(concept_name) == nil
            return "One of the concepts doesn't exist. Upload aborted"
        end
        return nil
    end
    
    def self.import(csv_path)
        rows = CSV.read(csv_path)
        if not self.verify_first_line(rows[0])
            return false
        end
        rows.shift
        file_t2c = {} 
        rows.each do |row|
            tag_name = row[0].strip if row[0]
            concept_name = row[1].strip if row[1]
            error = verify_row(tag_name, concept_name)
            if error
                return {:error => error}
            end
            if file_t2c[tag_name]
                file_t2c[tag_name] << concept_name   
            else
                file_t2c[tag_name] = [concept_name]
            end
        end
        return cross_check_diffs(file_t2c)
    end
    
    def self.cross_check_diffs(file_t2c)
        #Returns a hash of additions and deletions.
        #Note the instances are in json form
        additions = []
        deletions = []
        #First check deletions
        Tag2concept.all.each do |exist_t2c|
            exist_tag = Tag.find(exist_t2c.tag_id)
            exist_concept = Concept.find(exist_t2c.concept_id)
            if file_t2c.key?(exist_tag.name)
                concepts_per_tag = file_t2c[exist_tag.name]
                unless concepts_per_tag.include?(exist_concept.name)
                    deletions << exist_t2c.serializable_hash
                end
            else
                deletions += [exist_t2c.serializable_hash]
            end
        end
    
        #Check for any additions
        file_t2c.keys.each do |tag_name|
            tag = Tag.find_by_name(tag_name)
            file_t2c[tag_name].each do |concept_name|
               concept = Concept.find_by_name(concept_name) 
               if not Tag2concept.find_by(:tag_id => tag.id,:concept_id => concept.id)
                    additions << {:tag_name => tag_name, :concept_name => concept_name}           
               end
            end
        end
        return {:additions => additions, :deletions => deletions}
    end
    
    def self.save_changes(changes)
        additions = changes[:additions]
        deletions = changes[:deletions]
        additions.each do |addition|
            tag = Tag.find_by_name(addition[:tag_name])
            concept = Concept.find_by_name(addition[:concept_name])
            tag.concepts << concept
        end
    
        deletions.each do |deletion|
            Tag2concept.find_by(deletion).destroy
        end
    end
end