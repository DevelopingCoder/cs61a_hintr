class CreateHintVotes < ActiveRecord::Migration
  def change
    create_table :hint_votes do |t|
      t.integer :vote_type
      t.references :user
      t.references :hint
    end
  end
end
