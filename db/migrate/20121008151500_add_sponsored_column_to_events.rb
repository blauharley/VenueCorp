class AddSponsoredColumnToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :sponsored, :boolean
  end

  def self.down
    remove_column :events, :sponsored, :boolean
  end
end
