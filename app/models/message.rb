class Message < ActiveRecord::Base
    validates :content, presence: true
    has_many :votes
    has_many :users, :through => :votes
end
