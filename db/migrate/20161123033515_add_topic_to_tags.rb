class AddTopicToTags < ActiveRecord::Migration
  def change
    add_column :tags, :topic, :string
  end
end
