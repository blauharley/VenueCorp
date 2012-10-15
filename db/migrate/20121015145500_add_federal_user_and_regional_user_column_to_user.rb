class AddFederalUserAndRegionalUserColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :events, :regional_user, :boolean
    add_column :events, :federal_user, :boolean
  end

  def self.down
    remove_column :events, :regional_user
    remove_column :events, :federal_user
  end
end
