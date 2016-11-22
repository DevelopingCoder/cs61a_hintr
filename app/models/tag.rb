class Tag < ActiveRecord::Base
    validates :name, presence: true
    validates :description, presence: true
    validates :example, presence: true
    has_many :tag2concepts
    has_many :concepts, :through => :tag2concepts
    
    include ActiveModel::Serialization
    
    def attributes
        {:name => name, :description => description, :example => example}    
    end
    def self.verify_first_line(first_line)
        first_line = first_line.split(",")
        if first_line.length < 10
          return false
        end
        
        verification = []
        verification.append first_line[0].include?("Old tag name")
        verification.append first_line[1].include?("cp")
        verification.append first_line[2].include?("Status")
        verification.append first_line[3].include?("Tag Name")
        verification.append first_line[4].include?("Description")
        verification.append first_line[5].include?("Example")
        verification.append first_line[6].include?("Primary Concept")
        verification.append first_line[7].include?("Topic")
        verification.append first_line[8].include?("Count in Tag to Concept Master")
        verification.append first_line[9].include?("Concepts")
        
        verification.each do |ver|
            if not ver
                return false
            end
        end
        return true
    end
    
    def self.import(file)
        first_line = file.readline
        if not self.verify_first_line(first_line)
            return false
        end
        
        file_tags = {}
        file.each do |line|
            columns = line.split(",")
            tag_name = columns[3].strip
            description = columns[4].strip
            example = columns[5].strip
            file_tags[tag_name] = [description, example]
        end
    
        return cross_check_diffs(file_tags)
    end
    
    def self.make_edit(exist_tag, upload_tag)
        #Check if there's an edit. If so, change it but don't save
        #Otherwise return False
        upload_description, upload_example = upload_tag
        change_discovered = false
        
        #Check if description changed
        if exist_tag.description != upload_description
            change_discovered = true
            exist_tag.description = upload_description
        end
        #Check if example changed
        if exist_tag.example != upload_example
            change_discovered = true
            exist_tag.example = upload_example
        end
        
        if change_discovered
            return exist_tag.serializable_hash
        end
        return change_discovered
        
    end
    
    def self.cross_check_diffs(file_tags)
        #Returns a hash of answers, edits, deletions. Answers and edits contains 
        #a message, which may be an empty string if we do not want to create a new message
        #Note the instances are in json form
        edits = []
        additions = []
        deletions = []

        #First check edits and deletions
        Tag.all.each do |exist_tag|
            if file_tags.key?(exist_tag.name)
                upload_tag = file_tags[exist_tag.name]
                any_edits = make_edit(exist_tag, upload_tag)
                if any_edits
                    edits += [any_edits]
                end
            else
                deletions += [exist_tag.serializable_hash]
            end
        end
        
        #Check for any additions
        file_tags.keys.each do |tag_name|
            #Check if not in tag not in db
            if not Tag.find_by_name(tag_name)
                desc, example = file_tags[tag_name]
                new_tag = Tag.new({:name => tag_name, :description => desc, :example => example})
                additions += [new_tag.serializable_hash]
            end
        end
        return {:additions => additions, :deletions => deletions, :edits => edits}
    end
    
    def self.save_changes(changes)
        additions = changes[:additions]
        deletions = changes[:deletions]
        edits = changes[:edits]
        additions.each do |addition|
            Tag.create(addition)
        end
        
        deletions.each do |deletion|
            Tag.find_by_name(deletion[:name]).destroy
        end
        
        edits.each do |edit|
            tag = Tag.find_by_name(edit[:name])
            tag.update(edit)
        end
    end
end