class AddHintStatusToTag2wronganswers < ActiveRecord::Migration
  def change
    add_column :tag2wronganswers, :hint_status, :string, default: "no hints"
  end
end
