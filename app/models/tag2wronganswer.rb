class Tag2wronganswer < ActiveRecord::Base
    validates :tag, presence: true
    validates :wrong_answer, presence: true
    belongs_to :tag
    belongs_to :wrong_answer
    has_many :hints
end
