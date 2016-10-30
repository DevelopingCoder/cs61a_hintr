class Tag < ActiveRecord::Base
    validates :name, presence: true
    valides :description, presence: true
    has_many :tag2concepts
end