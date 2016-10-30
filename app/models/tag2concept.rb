class Tag2Concept < ActiveRecord::Base
   validates :tag, presence: true
   validates :concept, presence: true
   belongs_to :tag
   belongs_to :concept
end