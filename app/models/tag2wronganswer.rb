class Tag2wronganswer < ActiveRecord::Base
    validates :tag, presence: true
    validates :wrong_answer, presence: true
    belongs_to :tag
    belongs_to :wrong_answer
    has_many :hints
    
    def self.get_id(wrong_answer, tag)
        tag2wronganswer =  Tag2wronganswer.where(:wrong_answer_id => wrong_answer.id).where(:tag_id => tag.id).first
        if tag2wronganswer
            return tag2wronganswer.id
        end
        # return -1 if error i.e. wrong_answer and tag are not associated
        return -1
    end
    
    def assigned_message
        if self.hints and self.hints.where(:finalized => true)
            return self.hints.where(:finalized => true).first
        else
            return nil
        end
    end
    
    def update_status
        if self.hints.length == 0
           self.update_attribute(:hint_status, "no hints")
        elsif self.hints.where(:finalized => true).exists?
            self.update_attribute(:hint_status, "assigned")
        else
            self.update_attribute(:hint_status, "in progress")
        end
    end
end
