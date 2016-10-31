class Message < ActiveRecord::Base
    validates :content, presence: true
    has_many :votes
    has_many :users, :through => :votes
    
    def vote(user_id, vote_type)
        puts "user_id: " + user_id.to_s + " vote_type: " + vote_type.to_s
        current_vote = self.votes.where(:user_id => user_id)
        if not current_vote.exists?
            current_vote = self.votes.create(:user_id => user_id, :vote_type => vote_type)
        elsif current_vote.vote_type != vote_type
            # only change vote if it's different from your first vote
            current_vote.update_attribute(:vote_type, vote_type)
        end
    end
    
    def upvotes
        return self.votes.where(:vote_type => 1).size.
    end
    
    def downvotes
        return self.votes.where(:vote_type => -1).size.
    end
end
