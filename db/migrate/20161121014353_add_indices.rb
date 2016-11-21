class AddIndices < ActiveRecord::Migration
  def change
    add_index :concepts, :name
    add_index :messages, :content
    add_index :tags, :name
  end
end
