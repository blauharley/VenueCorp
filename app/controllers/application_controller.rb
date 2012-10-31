require 'csv'
require 'categories'
require 'venues'
require 'uri'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def get_navi_vars
    
    @main_cat_clicked = nil
    @sub_cat_clicked = nil
    @federal_state_clicked = nil
    @region_clicked = nil
    
    @all_venues = {}
    Venues.get_federal_countries.each do |k,v|
    
      @all_venues[k] = []
      
      Venues.get_venues(k).each do |venues|
        number = Event.find(:all, :conditions => ['city = ?',venues]).count
        @all_venues[k].push({ :name => venues, :number => number })
      end
      
    end
    
    @all_event_cats = {}
    Categories.get_main_cats.each do |k,v|
    
      @all_event_cats[k] = []
      
      Categories.get_sub_cats(k).each do |sub_cat|
        number = Event.find(:all, :conditions => ['sub_category = ?',sub_cat]).count
        @all_event_cats[k].push({ :name => sub_cat, :number => number })
      end
      
    end
  end
  
end
