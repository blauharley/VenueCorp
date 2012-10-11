class EventsController < ApplicationController
  
  before_filter :get_event_cats_and_venues, :only => [:new, :edit]
  
  before_filter :get_navi_vars, :only => [:show]
  
  def show
    @event = Event.find(params[:id])
  end
  
  def new
    @event = Event.new
    check_logged_in_user
  end
  
  def create
    event = Event.new
    
    set_event_attr event, params[:event]
    
    if event.save
      redirect_to :root, :notice => 'Veranstaltung erfolgreich hinzugefügt'
    else
      redirect_to :root, :notice => 'Veranstaltung konnte nicht angelegt werden'
    end
  end
  
  def edit
    @event = Event.find(params[:id])
    check_logged_in_user
  end
  
  def update
    event = Event.find(params[:id])
    
    set_event_attr event, params[:event]
    
    if event.save
      redirect_to :root, :notice => 'Veranstaltung erfolgreich bearbeitet.'
    else
      redirect_to :root, :notice => 'Veranstaltung konnte nicht bearbeitet werden.'
    end
  end
  
  def destroy
    Event.find(params[:id]).destroy
    redirect_to :root, :notice => 'Veranstaltung erfolgreich gelöscht.'
  end
  
  def pdf_event
    event = Event.find(params[:id])
    pdf_path = (Prawn::Document.generate((event.title + ".pdf")) do
              move_down 10
              text 'Veranstaltung:'
              move_down 3
              t = make_table([ ['Titel', event.title],
                             ['Beschreibung', event.description],
                             ['Hauptkategorie', event.main_category],
                             ['Unterkategorie', event.sub_category],
                             ['Ort', event.venue],
                             ['Veranstaltungsort', event.venue],
                             ['Region', event.region],
                             ['Bundesland', event.province],
                             ['Bundes-Highlight', event.federal_highlight.to_s],
                             ['Regional-Highlight', event.regional_highlight.to_s],
                             ['Gesponsort', event.sponsored.to_s],
                             ['Start-Datum', event.start_date.strftime('%Y/%m/%d')],
                             ['End-Datum', event.end_date.strftime('%Y/%m/%d')],
                             ['Start-Tageszeit', event.start_date_time.strftime('%H:%M:%S')],
                             ['Ende-Tageszeit', event.end_date_time.strftime('%H:%M:%S')],
                             ['Veranstaltungsort-Url', event.venue_url],
                             ['Email', event.email],
                             ['Tel. Nr.', event.tel_nr],
                             ['Adresse', event.address],
                             ['Kosten', event.costs] ])
              t.draw
              if event.image.exists?
                image event.image.path, :position => :right, :vposition => 20, :width => 100, :height => 100
              end
           end).path
    send_file( pdf_path, :type => 'application/pdf',:disposition => 'inline')
  end
  
  def pdf_events
    events = []
    params[:ids].split(',').each do |id|
      events << Event.find(id)
    end
    
    pdf_path = (Prawn::Document.generate((events[0].title + ".pdf")) do
              move_down 10
              text 'Veranstaltungen:'
              move_down 3
              
              events.each do |event|
                move_down 5
                t = make_table([ ['Titel', event.title],
                               ['Beschreibung', event.description],
                               ['Hauptkategorie', event.main_category],
                               ['Unterkategorie', event.sub_category],
                               ['Ort', event.venue],
                               ['Veranstaltungsort', event.venue],
                               ['Region', event.region],
                               ['Bundesland', event.province],
                               ['Bundes-Highlight', event.federal_highlight.to_s],
                               ['Regional-Highlight', event.regional_highlight.to_s],
                               ['Gesponsort', event.sponsored.to_s],
                               ['Start-Datum', event.start_date.strftime('%Y/%m/%d')],
                               ['End-Datum', event.end_date.strftime('%Y/%m/%d')],
                               ['Start-Tageszeit', event.start_date_time.strftime('%H:%M:%S')],
                               ['Ende-Tageszeit', event.end_date_time.strftime('%H:%M:%S')],
                               ['Veranstaltungsort-Url', event.venue_url],
                               ['Email', event.email],
                               ['Tel. Nr.', event.tel_nr],
                               ['Adresse', event.address],
                               ['Kosten', event.costs] ])
                  t.draw
                  if event.image.exists?
                    image event.image.path, :position => :right, :vposition => 20, :width => 100, :height => 100
                  end 
                  start_new_page
              end
           end).path
    send_file( pdf_path, :type => 'application/pdf',:disposition => 'inline')
  end
  
  def ics_event
    
    event = Event.find(params[:id])
    
    cal = Icalendar::Calendar.new
    cal.event do
      dtstart       event.start_date.to_s
      dtend         event.end_date.to_s
      summary       event.title
      description   event.description
      klass         "Public"
    end

    send_data(cal.to_ical, :filename=>"mycal.ics", :disposition=>"inline; filename=mycal.ics", :type=>"text/calendar")
  end
  
  def get_all_rss_feed
    @events = Event.all
    
    respond_to do |format|
      format.rss { render 'get_rss_feed' }
    end
  end
  
  def get_rss_feed
    ids = params[:ids].split(',')
    @events = []
    
    ids.each do |id|
      @events << Event.find(id)
    end
    
    respond_to do |format|
      format.rss { render rss: @events }
    end
  end
  
  def get_events_by_format
    @events = []
    values = params[:value].split(',')
    values.each do |val|
      event = Event.where(params[:attr] => val)
      if !event.empty?
        event.each do |e|
          @events << e
        end
      end
    end
    
    @events = @events.sort
    
    respond_to do |format|
      format.xml { render xml: @events.to_xml }
      format.json { render json: @events.to_json }
    end
  end
  
  private
  
  def get_event_cats_and_venues
    
    @federal_countries = { 'Wähle Bundesland' => '' }
    @federal_countries = @federal_countries.merge(Venues.get_federal_countries)
    
    @venues  = []
    Venues.get_federal_countries.each do |k,v|
      venue = Venues.get_venues k
      venue = venue.sort
      @venues << { k =>  venue }
    end
    
    @main_event_cats = { 'Wähle Hauptkategorie' => '' }
    @main_event_cats = @main_event_cats.merge(Categories.get_main_cats)
    
    @event_cats  = []
    Categories.get_main_cats.each do |k,v|
      sub_cat = Categories.get_sub_cats k
      sub_cat = sub_cat.sort
      @event_cats << { k =>  sub_cat }
    end
    
  end
  
  
  def set_event_attr event, params
    
    event_start_time = params['start_date'] + ' ' + params['start_date_time']
    event_end_time = params['end_date'] + ' ' + params['end_date_time']
    reg_highlight = if params['regional_highlight'].to_i == 0 then false else true end
    fed_highlight = if params['federal_highlight'].to_i == 0 then false else true end
    sponsored = if params['sponsored'].to_i == 0 then false else true end
    
    start_date = Date.parse(event_start_time)
    repeat_dates = params['repeat_dates'].split(' ')
    formated_dates = ''
    
    if repeat_dates[0] != 'nie' && repeat_dates[1] && repeat_dates[1] > '0'
      for i in 0...repeat_dates[1].to_i
        formated_dates += (start_date + repeat_dates[0].to_i.days).to_s + ' '
        start_date = (start_date + repeat_dates[0].to_i.days)
      end
    end
    
    if current_user
      event.user = current_user
    end
    
    event.update_attributes(params)
    event.update_attributes(:start_date_time => event_start_time, :end_date_time => event_end_time, :regional_highlight => reg_highlight, :federal_highlight => fed_highlight, :sponsored => sponsored, :repeat_dates => formated_dates)

  end
  
  private
  
  def check_logged_in_user
    # first condition: edit foreign,  second condition: new, third condition: edit my own
    if (current_user && !@event.title.empty? && current_user.id != @event.user_id) || (current_user && !@event.title.empty? && @event.user_id == nil) || (current_user && current_user.id != @event.user_id && !@event.title.empty?)
      redirect_to :root, :notice => 'Sie müssen sich einloggen, um Veranstaltungen hinzuzufügen, bearbeiten oder löschen zu können.'
    end
  end
  
end
