class Concept < ActiveRecord::Base
    validates :name, presence: true
    validates :description, presence: true
    has_many :messages
    has_many :tag2concepts
    has_many :tags, :through => :tag2concepts
    
  def self.import(current_user, file)
    concepts_created = []
    read_first_line = false
    File.open(file.tempfile).each do |line|
      if not read_first_line
        read_first_line = true
        next
      end
      
      concept_name, description = line.split(",")
      if concept_name and description
          concept_name = concept_name.strip
          description = description.strip
          if Concept.create({:name => concept_name, :description => description})
            concepts_created += [concept_name]
          end
      end
    end
    return "Concepts Created: " + concepts_created.join(", ")
  end
  
  def update_status
        self.messages.each do |message|
            puts message.finalized.to_s
        end
        if not self.messages
           self.update_attribute(:msg_status, "no messages")
        elsif Message.where(:concept_id => self.id).where(:finalized => true).exists?
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
  
end