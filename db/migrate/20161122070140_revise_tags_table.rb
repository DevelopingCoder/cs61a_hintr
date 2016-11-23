class ReviseTagsTable < ActiveRecord::Migration
  def change
    remove_column :tags, :old_name
    remove_column :tags, :status
    remove_column :tags, :primary_concept
  end
end
