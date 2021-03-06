﻿class VenueController < ApplicationController
  
  before_filter :get_navi_vars, :only => [:index, :get_main_cat_events, :get_sub_cat_events, :get_federal_country, :get_venue, :get_events_by_date, :get_events_by_geocoding, :get_user_list]
  before_filter :get_sponsored_events
  
  def index
    if (params[:cat] == 'federal' || params[:cat] == 'regional') && params[:highlight] == 'true'
      if params[:cat] == 'federal'
        @events = Event.where( :federal_highlight => true ).order('start_date asc')
      elsif params[:cat] == 'regional'
        @events = Event.where( :regional_highlight => true ).order('start_date asc')
      end
    else
      @events = Event.search(params[:search])
    end
  end
  
  def get_main_cat_events
    @events = Event.find(:all, :conditions => ['main_category = ?',params[:cat]], :order => "start_date asc")
    @main_cat_clicked = params[:cat]
    render 'index'
  end
  
  def get_sub_cat_events
    @events = Event.find(:all, :conditions => ['sub_category = ?',params[:cat]], :order => "start_date asc")
    @main_cat_clicked = Categories.get_main_cat_by_sub_cat params[:cat]
    @sub_cat_clicked = params[:cat]
    render 'index'
  end
  
  def get_federal_country
    @events = Event.find(:all, :conditions => ['province = ?',params[:country]], :order => "start_date asc")
    @federal_state_clicked = params[:country]
    render 'index'
  end
  
  def get_venue
    @events = Event.find(:all, :conditions => ['city = ?',params[:city]], :order => "start_date asc")
    @federal_state_clicked = Venues.get_federal_countries_by_vene params[:city]
    @region_clicked = params[:city]
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
  
  def get_events_by_geocoding
    marker_place = Geocoder.search(params[:latlng])
    if marker_place.nil?
      redirect_to :root, :notice => 'Die Google-API kann momentan nicht benutzt werden.'
      return
    end
    
    @events = []
    
    Event.all.each do |event|
      distance_diff = event.distance_to(marker_place[0].address)
      if distance_diff && (distance_diff *1.6) <= 20 # radius 20 km
        @events << event
      end
    end
    render 'index'
  end
  
  def get_user_list
    if !current_admin
      redirect_to :root, :notice => 'Keine Berechtigung!'
      return 
    end
    
    @users = User.find(:all, :order => "email asc")
  end
  
  def contact
  end
  
  def send_contact_mail
    user = '(Nicht registriert!)'
    if current_user
      user = current_user
    elsif current_admin
      user = current_admin
    end
    UserMailer.send_contact_mail(user, params[:subject],params[:body]).deliver
    redirect_to :root, :notice => 'Wir werden ihre Nachricht in kürze beantworten.'
  end
  
  def search_surrounding_events
    if request.location && request.location.city.length > 0
      @location = request.location.city + ', ' + request.location.country
    else
      @location = ''
    end
  end
  
  def sitemap
    render :text => File.read(Dir.pwd << 'public/sitemap.xml')
  end
  
  private
  
  def get_sponsored_events
    @sponsored_events = Event.where( :sponsored => true ).order('start_date asc')
  end
  
end
