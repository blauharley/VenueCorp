class ChangeDatabaseEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :description, :string
    add_column :events, :address, :string
    add_column :events, :costs, :string
    remove_column :events, :long_description
    remove_column :events, :short_description
  end

  def self.down
    remove_column :events, :description
    remove_column :events, :address
    add_column :events, :costs
  end
end
