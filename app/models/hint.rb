class Hint < ActiveRecord::Base
    belongs_to :tag2wronganswers
    has_many :hint_votes
    has_many :users, :through => :hint_votes
end
