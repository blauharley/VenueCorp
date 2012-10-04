class VenueController < ApplicationController
  
  before_filter :get_navi_vars, :only => [:index, :get_main_cat_events, :get_sub_cat_events, :get_federal_country, :get_venue, :get_events_by_date]
  
  def index
    if params[:highlight] == 'true'
      @events = Event.where( :highlight => true ).order('start_date')
    else
      @events = Event.search(params[:search])
    end
  end
  
  def get_main_cat_events
    @events = Event.find(:all, :conditions => ['main_category = ?',params[:cat]], :order => "title asc")
    render 'index'
  end
  
  def get_sub_cat_events
    @events = Event.find(:all, :conditions => ['sub_category = ?',params[:cat]], :order => "title asc")
    render 'index'
  end
  
  def get_federal_country
    @events = Event.find(:all, :conditions => ['province = ?',params[:country]], :order => "title asc")
    render 'index'
  end
  
  def get_venue
    @events = Event.find(:all, :conditions => ['city = ?',params[:city]], :order => "title asc")
    render 'index'
  end
  
  def get_events_by_date
    search_date = Date.parse(URI.unescape(params[:start_date]))
    
    @events = []
    Event.all.each do |event|
      
      if event.start_date == search_date
        @events << event
      else
        if event.repeat_dates != 'never'
          dates = event.repeat_dates.split(' ')
          dates.each do |date|
            if search_date.strftime('%Y-%m-%d') == date
              @events << event
            end
          end
        end
      end
    end
    
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
  
end
