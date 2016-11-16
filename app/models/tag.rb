class Tag < ActiveRecord::Base
    validates :name, presence: true
    validates :description, presence: true
    has_many :tag2concepts
    has_many :tag2wronganswers
    has_many :concepts, :through => :tag2concepts
    has_many :wrong_answers, :through => :tag2wronganswers
end