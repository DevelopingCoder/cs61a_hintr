class WrongAnswer < ActiveRecord::Base
    has_many :tags2wronganswers
    has_many :tags, :through => :tags2wronganswers
    belongs_to :question
end
