require 'spec_helper'

describe Hint do
    describe 'creation' do 
        before(:each) do 
            @tag1 = Tag.create!({:name => "Example_tag", :description => "This is my example tag", :example => "tag + tag = 2", :topic => "too much blue"})
            @wa = WrongAnswer.create!({:text => "this is a wrong answer", :question_id => 1}) #Question_id doesn't exist
            @tag2wa = Tag2wronganswer.create!({:tag_id => @tag1.id, :wrong_answer_id => @wa.id})
        end
        it 'must be unique to a wa_tag' do 
            first = Hint.create!({:content => "m1", :tag2wronganswer_id => @tag2wa.id})
            expect{Hint.create!({:content => "m1", :tag2wronganswer_id => 
                        @tag2wa.id})}.to raise_error(ActiveRecord::RecordInvalid)
        end
    end
end
