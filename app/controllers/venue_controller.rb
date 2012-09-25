require 'rest_client'

class VenueController < ApplicationController
  
  after_filter :write_note, :only => [:get_events]
  
  def index
    if params[:highlight] == 'true'
      @events = Event.where( :highlight => true )
      flash[:notice] = params[:highlight]
    else
      @events = Event.search(params[:search])
    end
  end
  
  def send_contact_mail
    API_KEY = ENV['MAILGUN_API_KEY']
    API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/mailgun.net"

    RestClient.post API_URL+"/messages", 
    :from => "ev@example.com",
    :to => "ev@mailgun.net",
    :subject => "This is subject",
    :text => "Text body",
    :html => "<b>HTML</b> version of the body!"
    #UserMailer.send_condact_mail.deliver
  end
  
  def show_early_events
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
  
  
end
