class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :province
      t.string :region
      t.string :city
      t.string :main_category
      t.string :sub_category
      t.boolean :highlight
      t.string :venue
      t.date :start_date
      t.date :end_date
      t.time :start_date_time
      t.time :end_date_time
      t.string :photo_url
      t.string :title
      t.text :short_description
      t.text :long_description
      t.string :venue_url
      t.string :email
      t.string :tel_nr

      t.timestamps
    end
  end
end
