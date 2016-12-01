require 'spec_helper'

describe Tag do
    describe 'Suggest Hints' do 
        before(:each) do 
            @tag1 = Tag.create!({:name => "Example_tag", :description => "This is my example tag", :example => "tag + tag = 2", :topic => "too much blue"})
            @wa = WrongAnswer.create!({:text => "this is a wrong answer", :question_id => 1}) #Question_id doesn't exist
            @tag2wa = Tag2wronganswer.create!({:tag_id => @tag1.id, :wrong_answer_id => @wa.id})
        end
        it 'doesnt have suggestions when the tag has no associated hints' do 
            expect(@tag1.related_hints(@tag2wa).length).to equal(0)
        end
        it 'gives us all hints created' do
            tag2wa_2 = Tag2wronganswer.create!({:tag_id => @tag1.id, :wrong_answer_id => @wa.id})
            tag2wa_3 = Tag2wronganswer.create!({:tag_id => @tag1.id, :wrong_answer_id => @wa.id})
            h1 = Hint.create!({:content => "hint 1", :tag2wronganswer_id => tag2wa_2.id})
            h2 = Hint.create!({:content => "hint 2", :tag2wronganswer_id => tag2wa_3.id})
            related = @tag1.related_hints(@tag2wa)
            expect(related.length).to equal(2)
            expect(related.include?("hint 1")).to be true
            expect(related.include?("hint 2")).to be true
        end
        it 'doesnt include hints we have already used' do
            tag2wa_2 = Tag2wronganswer.create!({:tag_id => @tag1.id, :wrong_answer_id => @wa.id})
            tag2wa_3 = Tag2wronganswer.create!({:tag_id => @tag1.id, :wrong_answer_id => @wa.id})
            h1 = Hint.create!({:content => "hint 1", :tag2wronganswer_id => tag2wa_2.id})
            h2 = Hint.create!({:content => "hint 2", :tag2wronganswer_id => tag2wa_3.id})
            Hint.create!({:content => "hint 2", :tag2wronganswer_id => @tag2wa.id})
            related = @tag1.related_hints(@tag2wa)
            expect(related.length).to equal(1)
            expect(related.include?("hint 2")).to be false
        end
    end
end
