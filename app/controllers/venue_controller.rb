﻿class VenueController < ApplicationController
  
  after_filter :write_note, :only => [:get_events]
  before_filter :get_number_of_cat_events, :only => [:index, :get_main_cat_events, :get_sub_cat_events]
  
  def index
    if params[:highlight] == 'true'
      @events = Event.where( :highlight => true ).order('start_date')
    else
      @events = Event.search(params[:search])
    end
    @event_sub_cats = []
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
  
  def send_contact_mail
    UserMailer.send_condact_mail.deliver
  end
  
  def show_early_events
    get_events 'early'
    redirect_to :back, :notice => @note
  end
  
  private
  
  def get_number_of_cat_events
    @event_main_cats = {}
    Categories.get_main_cats.each do |k,v|
      @event_main_cats[k] = Event.find(:all, :conditions => ['main_category = ?',k]).count
    end
  end
  
  def get_events cat
    if cat == 'early'
      date = Date.today
      @events = Hash.new
      for i in 0...6
        @events[i] = Event.where( :start_date => date ).order('start_date asc')
        date = date.next
      end
      
      event_array = []
      @events.each do |index,value|
        for events in value
          event_array << events
        end
      end
      @events = event_array
      
    elsif cat == 'place'
      @events = Event.find(:all).group_by(&:city).order('city asc')
    elsif cat == 'group'
      @events = Event.find(:all).group_by(&:city)
    end
    
  end
  
  def write_note
    @note = ''
    if @events.empty?
      @note = 'Leider keine Treffer'
    else
      @note = 'Suche erfolgreich!'
    end
  end
  
  
end
