class Event < ActiveRecord::Base
  attr_accessible :city, :email, :end_date, :end_date_time, :highlight, :long_description, :main_category, :photo_url, :province, :region, :short_description, :start_date, :start_date_time, :sub_category, :tel_nr, :title, :venue, :venue_url
   
  def self.search(attr, value)
    if attr && value
      where(attr => value)
    else
      all
    end
  end
  
  
  def print_attr
    city.to_s << ', ' << email.to_s << ', ' << end_date.to_s << ', ' << end_date_time.to_s << ', ' << highlight.to_s << ', ' << long_description.to_s << ', ' << main_category.to_s << ', ' << photo_url.to_s << ', ' << province.to_s << ', ' << region.to_s << ', ' << short_description.to_s << ', ' << start_date.to_s << ', ' << start_date_time.to_s << ', ' << sub_category.to_s << ', ' << tel_nr.to_s << ', ' << title.to_s << ', ' << venue.to_s << ', ' << venue_url.to_s 
  end
  
end
