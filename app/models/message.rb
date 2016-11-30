class Message < ActiveRecord::Base
    validates :content, presence: true
    validate :is_unique

    belongs_to :concept
    
    has_many :votes, dependent: :destroy
    has_many :users, :through => :votes
    
    def is_unique
        if self.concept_id
            concept = Concept.find_by_id(self.concept_id)
            concept.messages.each do |message|
                if message.content == self.content
                    errors.add(:message, "already exists for the concept")
                end
            end
        end
    end
    
    def vote(user_id, vote_type)
        current_vote = self.votes.where(:user_id => user_id)
        if not current_vote.exists?
            current_vote = self.votes.create(:user_id => user_id, :vote_type => vote_type)
        elsif current_vote.first.vote_type != vote_type
            #Checks if we're changing our vote
            current_vote.first.update_attribute(:vote_type, vote_type)
        else
            #We're toggling the vote back to neutral
            current_vote.first.update_attribute(:vote_type, 0)
        end
    end
    
    def upvotes
        return self.votes.where(:vote_type => 1).size
    end
    
    def downvotes
        return self.votes.where(:vote_type => -1).size
    end
    
    def finalizable
        if (self.upvotes.to_i >= Rails.application.config.threshold.to_i) and not self.finalized
            return true
        else
            return false
        end
    end
    
    def finalize
        concept = Concept.find(self.concept_id)
        last_assigned_message = concept.assigned_message
        if last_assigned_message
            last_assigned_message.update_attribute(:finalized, false)
        end
        self.update_attribute(:finalized, true)
        concept.update_attribute(:msg_status, "assigned")
    end
    
    def unfinalize
        concept = Concept.find(self.concept_id)
        if self.finalized
            self.update_attribute(:finalized, false)
        end
        concept.update_status
    end
    
end