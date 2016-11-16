class CreateWrongAnswers < ActiveRecord::Migration
  def change
    create_table :wrong_answers do |t|
      t.string :text
      t.references :question
    end
  end
end
