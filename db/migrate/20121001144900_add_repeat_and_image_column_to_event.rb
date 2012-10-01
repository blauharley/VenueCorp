class AddRepeatAndImageColumnToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :repeat, :string
    add_attachment :events, :image 
    remove_column :events, :photo_url
  end

  def self.down
    remove_column :events, :repeat
    remove_attachment :events, :image
  end
end
