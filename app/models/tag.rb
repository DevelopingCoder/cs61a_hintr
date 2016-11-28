require 'csv'
class Tag < ActiveRecord::Base
    validates :name, presence: true
    validates :description, presence: true
    validates :example, presence: true
    has_many :tag2concepts, dependent: :destroy
    has_many :tag2wronganswers, dependent: :destroy
    has_many :concepts, :through => :tag2concepts
    has_many :wrong_answers, :through => :tag2wronganswers
    
    include ActiveModel::Serialization
    
    def attributes
        {:name => name, :description => description, :example => example, :topic => topic}    
    end
    def self.verify_first_line(first_line)
        if first_line.length < 10
          return false
        end
        
        verification = []
        verification.append first_line[3].include?("Tag Name")
        verification.append first_line[4].include?("Description")
        verification.append first_line[5].include?("Example")
        verification.append first_line[7].include?("Topic")
        verification.each do |ver|
            if not ver
                return false
            end
        end
        return true
    end
    
    def self.import(csv_path)
        rows = CSV.read(csv_path)
        if not self.verify_first_line(rows[0])
            return false
        end
        rows.shift
        
        file_tags = {}
        rows.each do |row|
            tag_name = row[3].strip if row[3]
            description = row[4].strip if row[4]
            example = row[5].strip if row[5]
            topic = row[7].strip if row[7]
            file_tags[tag_name] = [description, example, topic]
        end
        return cross_check_diffs(file_tags)
    end
    
    def self.make_edit(exist_tag, upload_tag)
        #Check if there's an edit. If so, change it but don't save
        #Otherwise return False
        upload_description, upload_example, upload_topic = upload_tag
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
        
        #Check if topic changed
        if exist_tag.topic != upload_topic
            change_discovered = true
            exist_tag.topic = upload_topic
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
                desc, example, topic = file_tags[tag_name]
                new_tag = Tag.new({:name => tag_name, :description => desc, :example => example, :topic => topic})
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