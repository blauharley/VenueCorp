class ChangeStringColumnDescriptionToTextColumn < ActiveRecord::Migration
  def self.up
    remove_column :events, :description
    add_column :events, :description, :text
  end

  def self.down
    remove_column :events, :description
  end
end
