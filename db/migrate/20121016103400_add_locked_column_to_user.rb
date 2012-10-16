class AddLockedColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :locked, :boolean
  end

  def self.down
    remove_column :users, :locked
  end
end
