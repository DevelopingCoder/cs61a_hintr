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
  
end