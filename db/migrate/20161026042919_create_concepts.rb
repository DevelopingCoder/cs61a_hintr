class CreateConcepts < ActiveRecord::Migration
  def change
    create_table :concepts do |t|
      t.string :name
      t.string :description
      t.string :msg_status
      t.integer :lab_first_appeared
    end
    
    create_table :messages do |t|
      t.string :content
      t.string :author
      t.references :concept
      t.boolean :finalized
      t.timestamps
    end
    
  end
end
