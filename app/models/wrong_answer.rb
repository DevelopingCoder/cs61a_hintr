class WrongAnswer < ActiveRecord::Base
    has_many :tag2wronganswers
    has_many :tags, :through => :tag2wronganswers
    belongs_to :question
    
    # takes in list of tags
    # assumes this is the valid tag list for a wrong answer (not case string)
    def is_edited(tag_list)
        db_tag_list = self.tags
        
        #find deletions
        db_tag_list.each do |tag|
            if not tag_list.include?(tag.name)
                return true
            end
        end
        #find additions
        tag_list.each do |tag|
            tag = Tag.find_by_name(tag)
            if not tag
                return true
            end
        end
        return false
    end
        
    def get_tags
        tag_list = Array.new
        self.tags.each do |tag|
            tag_list.push(tag.name)
        end
        return tag_list
    end
    
    def associate_tags(tag_list)
        tag_list.each do |tag_name|
            tag = Tag.find_by_name(tag_name)
            if tag
                self.tags << tag
            end
        end
    end
end
