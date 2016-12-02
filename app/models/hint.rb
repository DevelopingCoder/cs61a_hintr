class Hint < ActiveRecord::Base
    belongs_to :tag2wronganswer
    validates :content, presence: :true
    validate :is_unique
    has_many :hint_votes, dependent: :destroy
    has_many :users, :through => :hint_votes
    
    def is_unique
        tag2wronganswer.hints.each do |hint|
            if hint.content == self.content
                errors.add(:hint, "already exists for the wa_tag")
            end
        end
    end
    
    def vote(user_id, vote_type)
        current_vote = self.hint_votes.where(:user_id => user_id)
        if not current_vote.exists?
            current_vote = self.hint_votes.create(:user_id => user_id, :vote_type => vote_type)
        elsif current_vote.first.vote_type != vote_type
            #Checks if we're changing our vote
            current_vote.first.update_attribute(:vote_type, vote_type)
        else
            #We're toggling the vote back to neutral
            current_vote.first.update_attribute(:vote_type, 0)
        end
    end
    
    def upvotes
        return self.hint_votes.where(:vote_type => 1).size
    end
    
    def downvotes
        return self.hint_votes.where(:vote_type => -1).size
    end
    
    def finalizable
        if (self.upvotes.to_i >= Rails.application.config.hintthreshold.to_i) and not self.finalized
            return true
        else
            return false
        end
    end
    
    def finalize
        tag2wronganswer = Tag2wronganswer.find(self.tag2wronganswer.id)
        last_assigned_message = tag2wronganswer.assigned_message
        if last_assigned_message
            last_assigned_message.update_attribute(:finalized, false)
        end
        self.update_attribute(:finalized, true)
        tag2wronganswer.update_attribute(:hint_status, "assigned")
    end
    
    def unfinalize
        tag2wronganswer = Tag2wronganswer.find(self.tag2wronganswer.id)
        if self.finalized
            self.update_attribute(:finalized, false)
        end
        tag2wronganswer.update_status
    end
end
