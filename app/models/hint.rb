class Hint < ActiveRecord::Base
    belongs_to :tag2wronganswer
    validates :content, presence: :true
    has_many :hint_votes
    has_many :users, :through => :hint_votes
end
