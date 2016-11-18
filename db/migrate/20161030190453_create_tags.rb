class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :old_name
      t.string :name
      t.string :status
      t.string :description
      t.string :primary_concept
      t.string :example
    end
    
    create_table :tag2concepts do |t|
      t.references :tag
      t.references :concept
    end
  end
end
