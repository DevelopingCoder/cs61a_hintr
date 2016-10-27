class Vote < ActiveRecord::Base
    belongs_to :message
    belongs_to :user
    validates :vote_type, :presence => true
end