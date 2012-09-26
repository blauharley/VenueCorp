class Event < ActiveRecord::Base
  attr_accessible :city, :email, :end_date, :end_date_time, :highlight, :main_category, :photo_url, :costs, :address, :province, :region, :description, :start_date, :start_date_time, :sub_category, :tel_nr, :title, :venue, :venue_url
   
  def self.search(value)
    if value
      hits_city = []
      hits_city += find(:all, :conditions => ['city like ?', '%' + value + '%']).order('start_date')
      if hits_city.empty?
        hits_city += find(:all, :conditions => ['city like ?', '%' + value.downcase + '%']).order('start_date')
      end
      
      hits_title = []
      hits_title += find(:all, :conditions => ['title like ?', '%' + value + '%']).order('start_date')
      if hits_title.empty?
        hits_title += find(:all, :conditions => ['title like ?', '%' + value.downcase + '%']).order('start_date')
      end
      
      hits_description = []
      hits_description += find(:all, :conditions => ['description like ?', '%' + value + '%']).order('start_date')
      if hits_description.empty?
        hits_description += find(:all, :conditions => ['description like ?', '%' + value.downcase + '%']).order('start_date')
      end
      
      hits = hits_city + hits_title + hits_description
      hits
    else
      all
    end
  end
  
  
  def print_attr
    city.to_s << ', ' << email.to_s << ', ' << end_date.to_s << ', ' << end_date_time.to_s << ', ' << costs.to_s << ', ' << address.to_s << ', ' << highlight.to_s << ', ' << description.to_s << ', ' << main_category.to_s << ', ' << photo_url.to_s << ', ' << province.to_s << ', ' << region.to_s << ', ' << start_date.to_s << ', ' << start_date_time.to_s << ', ' << sub_category.to_s << ', ' << tel_nr.to_s << ', ' << title.to_s << ', ' << venue.to_s << ', ' << venue_url.to_s 
  end
  
end
