class VenueController < ApplicationController
  
  after_filter :write_note, :only => [:get_events]
  
  def index
    @events = Event.search(params[:attr], params[:search])
  end
  
  def show_early_events
    get_events 'early'
    redirect_to :back, :notice => @note
  end
  
  def show_place_events
    get_events 'early'
    redirect_to :back, :notice => @note
  end
  
  def show_group_events
    get_events 'early'
    redirect_to :back, :notice => @note
  end
  
  private
  
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
  
  def redirect_to_events
    redirect_to :root, :notice => @note
  end
  
end
