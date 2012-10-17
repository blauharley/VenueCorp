class AddImageUrlColumnToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :image_url, :string
  end

  def self.down
    remove_column :events, :image_url
  end
end
