class Tag < ActiveRecord::Base
    validates :name, presence: true
    valides :description, presence: true
    has_many :tag2concepts
    has_many :concepts, :through => :tag2concepts
end