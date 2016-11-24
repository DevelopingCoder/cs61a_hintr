class HintVote < ActiveRecord::Base
    belongs_to :hint
    belongs_to :user
    validates :vote_type, :presence => true
end
