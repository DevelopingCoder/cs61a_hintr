require 'spec_helper'

describe Message do
    describe 'creation' do 
        it 'must be unique to a concept' do 
            concept = FactoryGirl.create(:concept)
            first = Message.create!({:content => "m1", :concept_id => concept.id})
            expect{Message.create!({:content => "m1", :concept_id => 
                    concept.id})}.to raise_error(ActiveRecord::RecordInvalid)
        end
    end
end
