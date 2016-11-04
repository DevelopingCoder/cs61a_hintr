class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :vote_type
      t.references :user
      t.references :message
    end
  end
end
