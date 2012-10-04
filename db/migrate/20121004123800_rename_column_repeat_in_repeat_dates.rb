class RenameColumnRepeatInRepeatDates < ActiveRecord::Migration
  def self.up
    remove_column :events, :repeat
    add_column :events, :repeat_dates, :string
  end

  def self.down
    remove_column :events, :repeat_dates
  end
end
