class Question < ActiveRecord::Base
    belongs_to :question_set
    has_many :wrong_answers
end
