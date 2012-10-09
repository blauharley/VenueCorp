class AddHighlightKindsToEvent < ActiveRecord::Migration
  def self.up
    remove_column :events, :highlight
    add_column :events, :federal_highlight, :boolean
    add_column :events, :regional_highlight, :boolean
  end

  def self.down
    remove_column :events, :federal_highlight
    remove_column :events, :regional_highlight
  end
end
