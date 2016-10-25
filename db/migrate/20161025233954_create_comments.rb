class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :upvotes
      t.integer :downvotes
      t.boolean :is_final

      t.timestamps null: false
    end
  end
end
