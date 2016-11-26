class CreateTag2wronganswers < ActiveRecord::Migration
  def change
    create_table :tag2wronganswers do |t|
      t.references :tag
      t.references :wrong_answer
    end
  end
end
