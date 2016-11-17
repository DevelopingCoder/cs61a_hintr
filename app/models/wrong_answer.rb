class WrongAnswer < ActiveRecord::Base
    has_many :tags2wronganswers
    has_many :tags, :through => :tags2wronganswers
    belongs_to :question
    
    # takes in list of tags
    # returns idk
    def is_edited(tag_list)
        db_tag_list = self.tags
        
        #find deletions
        db_tag_list.each do |tag|
            if tag.name not in tag_list
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
end
