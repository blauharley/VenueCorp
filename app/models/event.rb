class Event < ActiveRecord::Base
  attr_accessible :city, :email, :end_date, :end_date_time, :regional_highlight, :federal_highlight, :main_category, :costs, :address, :province, :region, :description, :start_date, :start_date_time, :sub_category, :tel_nr, :title, :venue, :venue_url, :image, :repeat_dates, :sponsored, :latitude, :longitude, :user_id, :user
  validates :title, :presence => true
  validates :region, :presence => true
  validates :province, :presence => true
  validates :city, :presence => true
  validates :main_category, :presence => true
  validates :venue, :presence => true
  validates :description, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :start_date_time, :presence => true
  validates :address, :presence => true
 
  belongs_to :user
  
  geocoded_by :address
  after_validation :geocode
  
  has_attached_file :image, 
                    :styles => { :medium => "300x300>", :thumb => "100x100>" }
                    #:default_style => :thumb,
                    #:url => "/images/:basename.:extension",
                    #:path => ":rails_root/public/images/:basename.:extension"
  
  def self.search(value)
    if value
      hits = []
      hits += find(:all, :conditions => ["title like ? OR city like ? OR description like ?", '%' + value + '%', '%' + value + '%', '%' + value + '%'], :order => "start_date asc")
      if hits.empty?
        hits += find(:all, :conditions => ["title like ? OR city like ? OR description like ?", '%' + value.downcase + '%', '%' + value.downcase + '%', '%' + value.downcase + '%'], :order => "start_date asc")
      end
      hits
    else
      order('start_date asc')
    end
  end
  
end
