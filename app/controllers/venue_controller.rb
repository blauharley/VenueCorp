class VenueController < ApplicationController
  
  after_filter :write_note, :only => [:get_events]
  before_filter :get_number_of_cat_events, :only => [:index, :get_main_cat_events, :get_sub_cat_events]
  
  def index
    if params[:highlight] == 'true'
      @events = Event.where( :highlight => true ).order('start_date')
    else
      @events = Event.search(params[:search])
    end
    @event_sub_cats = {}
  end
  
  def get_main_cat_events
    @events = Event.find(:all, :conditions => ['main_category = ?',params[:cat]])
    @event_sub_cats = {}
    Categories.get_sub_cats(params[:cat]).each do |sub_cat|
      @event_sub_cats[sub_cat] = Event.find(:all, :conditions => ['sub_category = ?',sub_cat]).count
    end
    
    render 'index'
  end
  
  def get_sub_cat_events
    @events = Event.find(:all, :conditions => ['sub_category = ?',params[:cat]])
    @event_sub_cats = {}
    Categories.get_sub_cats(@events[0].main_category).each do |sub_cat|
      @event_sub_cats[sub_cat] = Event.find(:all, :conditions => ['sub_category = ?',sub_cat]).count
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
  
  def get_number_of_cat_events
    @event_main_cats = {}
    Categories.get_main_cats.each do |k,v|
      @event_main_cats[k] = Event.find(:all, :conditions => ['main_category = ?',k]).count
    end
  end
  
end
