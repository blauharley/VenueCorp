class Event < ActiveRecord::Base
  attr_accessible :city, :email, :end_date, :end_date_time, :highlight, :main_category, :photo_url, :costs, :address, :province, :region, :description, :start_date, :start_date_time, :sub_category, :tel_nr, :title, :venue, :venue_url
   
  def self.search(value)
    if value
      hits = []
      hits += find(:all, :conditions => ["city like ? OR title like ? OR description like ?", '%' + value + '%', '%' + value + '%', '%' + value + '%'], :order => "start_date asc")
      if hits.empty?
        hits += find(:all, :conditions => ["city like ? OR title like ? OR description like ?", '%' + value.downcase + '%', '%' + value.downcase + '%', '%' + value.downcase + '%'], :order => "start_date asc")
      end
      hits
    else
      order('start_date asc')
    end
  end
  
  
  def print_attr
    city.to_s << ', ' << email.to_s << ', ' << end_date.to_s << ', ' << end_date_time.to_s << ', ' << costs.to_s << ', ' << address.to_s << ', ' << highlight.to_s << ', ' << description.to_s << ', ' << main_category.to_s << ', ' << photo_url.to_s << ', ' << province.to_s << ', ' << region.to_s << ', ' << start_date.to_s << ', ' << start_date_time.to_s << ', ' << sub_category.to_s << ', ' << tel_nr.to_s << ', ' << title.to_s << ', ' << venue.to_s << ', ' << venue_url.to_s 
  end
  
end
