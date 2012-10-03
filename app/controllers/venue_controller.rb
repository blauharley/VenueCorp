class VenueController < ApplicationController
  
  before_filter :get_cat_events_and_venues, :only => [:index, :get_main_cat_events, :get_sub_cat_events, :get_federal_country, :get_venue]
  
  def index
    if params[:highlight] == 'true'
      @events = Event.where( :highlight => true ).order('start_date')
    else
      @events = Event.search(params[:search])
    end
  end
  
  def get_main_cat_events
    @events = Event.find(:all, :conditions => ['main_category = ?',params[:cat]])
    render 'index'
  end
  
  def get_sub_cat_events
    @events = Event.find(:all, :conditions => ['sub_category = ?',params[:cat]])
    render 'index'
  end
  
  def get_federal_country
    @events = Event.find(:all, :conditions => ['province = ?',params[:country]])
    render 'index'
  end
  
  def get_venue
    @events = Event.find(:all, :conditions => ['city = ?',params[:city]])
    render 'index'
  end
  
  def contact
    
  end
  
  def send_contact_mail
    UserMailer.send_contact_mail('test-user', params[:title],params[:body]).deliver
    redirect_to :root, :notice => 'Wir werden ihre Nachricht bald beantworten.'
  end
  
  
  private
  
  def get_venues
    @all_venues = {}
    Venues.get_federal_countries.each do |k,v|
    
      @all_venues[k] = []
      
      Venues.get_venues(k).each do |venues|
        number = Event.find(:all, :conditions => ['city = ?',venues]).count
        @all_venues[k].push({ :name => venues, :number => number })
      end
      
    end
  end
  
  def get_cat_events_and_venues
    
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
