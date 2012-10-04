class Event < ActiveRecord::Base
  attr_accessible :city, :email, :end_date, :end_date_time, :highlight, :main_category, :costs, :address, :province, :region, :description, :start_date, :start_date_time, :sub_category, :tel_nr, :title, :venue, :venue_url, :image, :repeat_dates
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  def self.search(value)
    if value
      hits = []
      hits += find(:all, :conditions => ["city like ? OR title like ? OR description like ?", '%' + value + '%', '%' + value + '%', '%' + value + '%'], :order => "title asc")
      if hits.empty?
        hits += find(:all, :conditions => ["city like ? OR title like ? OR description like ?", '%' + value.downcase + '%', '%' + value.downcase + '%', '%' + value.downcase + '%'], :order => "title asc")
      end
      hits
    else
      order('start_date asc')
    end
  end
  
end
