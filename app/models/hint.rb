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
end
