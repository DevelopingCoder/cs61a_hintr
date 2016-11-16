class CreateHints < ActiveRecord::Migration
  def change
    create_table :hints do |t|
      t.string :content
      t.boolean :finalized
      t.datetime :created_at
      t.datetime :updated_at
      t.references :tag2wronganswer
    end
  end
end
