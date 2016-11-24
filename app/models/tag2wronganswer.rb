class Tag2wronganswer < ActiveRecord::Base
    validates :tag, presence: true
    validates :wrong_answer, presence: true
    belongs_to :tag, :dependent => :destroy
    belongs_to :wrong_answer, :dependent => :destroy
    has_many :hints
end
