class AddDefaultValuesToEventColumns < ActiveRecord::Migration
  def change
    change_column_default :events, :province, ''
    change_column_default :events, :region, ''
    change_column_default :events, :city, ''
    change_column_default :events, :main_category, ''
    change_column_default :events, :sub_category, ''
    change_column_default :events, :highlight, false
    change_column_default :events, :start_date, Date.today
    change_column_default :events, :end_date, Date.today
    change_column_default :events, :start_date_time, Time.now
    change_column_default :events, :end_date_time, Time.now
    change_column_default :events, :title, ''
    change_column_default :events, :email, ''
    change_column_default :events, :tel_nr, ''
    change_column_default :events, :description, ''
    change_column_default :events, :address, ''
    change_column_default :events, :costs, ''
    change_column_default :events, :repeat, ''
    change_column_default :events, :address, ''
    change_column_default :events, :venue, ''
    change_column_default :events, :venue_url, ''
    
  end
end
