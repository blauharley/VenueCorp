class AddFederalUserAndRegionalUserColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :regional_user, :boolean
    add_column :users, :federal_user, :boolean
  end

  def self.down
    remove_column :users, :regional_user
    remove_column :users, :federal_user
  end
end
