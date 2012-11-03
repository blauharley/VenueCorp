class EventsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper 
  
  before_filter :get_event_cats_and_venues, :only => [:new, :edit]
  
  before_filter :get_navi_vars, :only => [:show]
  
  def show
    @event = Event.find(params[:id])
  end
  
  def new
    @event = Event.new
    
    if request.location && request.location.city.length > 0
      @location = request.location.city + ', ' + request.location.country
    else
      @location = ''
    end
    check_logged_in_user
  end
  
  def create
    event = Event.new
    
    set_event_attr event, params[:event]
    
    if event.save
      redirect_to :root, :notice => 'Veranstaltung erfolgreich hinzugefügt'
    else
      render 'new'
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
      render 'edit'
    end
  end
  
  def destroy
    Event.find(params[:id]).destroy
    redirect_to :root, :notice => 'Veranstaltung erfolgreich gelöscht.'
  end
  
  def pdf_event
    event = Event.find(params[:id])
    html_stripped_description = strip_tags(event.description)
    
    pdf_path = (Prawn::Document.generate((event.title + ".pdf")) do
              move_down 10
              if event.federal_highlight
                text 'Bundes-Highlight:', :size => 20
              elsif event.regional_highlight
                text 'Regional-Highlight:', :size => 20
              elsif !event.federal_highlight && !event.regional_highlight
                text 'Veranstaltung:', :size => 20
              end
              
              move_down 5
              text event.title, :size => 18
              move_down 2
              text event.main_category << '/' << event.sub_category
              move_down 2
              text 'Start-Datum: ' << event.start_date.strftime('%d.%b %Y')
              move_down 2
              text 'Start-Zeit: ' << event.start_date_time.strftime('%H:%M:%S')
              move_down 2
              text 'Ende-Datum: ' << event.end_date.strftime('%d.%b %Y')
              move_down 2
              text 'Ende-Zeit: ' << event.end_date_time.strftime('%H:%M:%S')
              
              if event.repeat_dates.length > 0
                move_down 2
                text 'Nächste-Daten: ' << event.start_date.strftime('%Y/%m/%d')
              end
              
              if event.image.exists?
                image event.image.path, :position => :right, :vposition => 10, :width => 150, :height => 100
              elsif event.image_url && event.image_url.length > 0 && URI.parse(event.image_url).kind_of?(URI::HTTP)
                begin 
                  image open(event.image_url).path, :position => :right, :vposition => 10, :width => 150, :height => 100
                rescue OpenURI::HTTPError => response
                  Rails.logger.info 'fetching File: ' << event.image_url << ' resulted to http-status: ' << response.exception.io.status[0].to_s
                end
              end
              
              move_down 3
              text html_stripped_description
              
              move_down 6
              t = make_table([ 
                             ['Veranstaltungsort', event.venue],
                             ['Adresse', event.address],
                             ['Kosten', if event.costs.length > 0 then event.costs else 'Keine Kosten angegeben' end],
                             ['Website', if event.venue_url.length > 0 then event.venue_url else 'Keine Website angegeben' end],
                             ['Email', if event.email.length > 0 then event.email else 'Keine Email angegeben' end],
                             ['Tel. Nr.', if event.tel_nr.length > 0 then event.tel_nr else 'Keine Website angegeben' end] ])
              t.draw
              
           end).path
    send_file( pdf_path, :type => 'application/pdf',:disposition => 'inline')
  end
  
  def pdf_events
    events = []
    html_stripped_descriptions = []
    
    params[:ids].split(',').each do |id|
      events << Event.find(id)
      html_stripped_descriptions << CGI::unescapeHTML(strip_tags(Event.find(id).description))
    end
    
    pdf_path = (Prawn::Document.generate((events[0].title + ".pdf")) do
              move_down 10
              text 'Gelistete Veranstaltungen: ', :size => 22
              move_down 6
              
              events.each_with_index do |event, index|
                move_down 10
                if event.federal_highlight
                  text 'Bundes-Highlight:', :size => 20
                elsif event.regional_highlight
                  text 'Regional-Highlight:', :size => 20
                elsif !event.federal_highlight && !event.regional_highlight
                  text 'Veranstaltung:', :size => 20
                end
                
                move_down 5
                text event.title, :size => 18
                move_down 2
                text event.main_category << '/' << event.sub_category
                move_down 4
                text 'Start-Datum: ' << event.start_date.strftime('%d.%b %Y')
                move_down 2
                text 'Start-Zeit: ' << event.start_date_time.strftime('%H:%M:%S')
                move_down 2
                text 'Ende-Datum: ' << event.end_date.strftime('%d.%b %Y')
                move_down 2
                text 'Ende-Zeit: ' << event.end_date_time.strftime('%H:%M:%S')
                
                if event.repeat_dates.length > 0
                  move_down 2
                  text 'Nächste-Daten: ' << event.start_date.strftime('%d.%b %Y')
                end
                
                
                
                move_down 3
                text html_stripped_descriptions[index]
                
                move_down 6
                t = make_table([ 
                               ['Veranstaltungsort', event.venue],
                               ['Adresse', event.address],
                               ['Kosten', if event.costs.length > 0 then event.costs else 'Keine Kosten angegeben' end],
                               ['Website', if event.venue_url.length > 0 then event.venue_url else 'Keine Website angegeben' end],
                               ['Email', if event.email.length > 0 then event.email else 'Keine Email angegeben' end],
                               ['Tel. Nr.', if event.tel_nr.length > 0 then event.tel_nr else 'Keine Website angegeben' end] ])
                t.draw
                
                if event.image.exists?
                  image event.image.path, :position => :right, :position => 340, :vposition => 10, :width => 150, :height => 100
                elsif event.image_url && event.image_url.length > 0 && URI.parse(event.image_url).kind_of?(URI::HTTP)
                  begin
                    image open(event.image_url).path, :position => :right, :position => 240, :vposition => 10, :width => 150, :height => 100
                  rescue OpenURI::HTTPError => response
                    Rails.logger.info 'fetching File: ' << event.image_url << ' resulted to http-status: ' << response.exception.io.status[0].to_s
                  end
                end
                
                start_new_page if events.last != event
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
    
    if current_user && event.user.nil?
      event.user = current_user
    end
    
    event.update_attributes(params)
    event.update_attributes(:start_date_time => event_start_time, :end_date_time => event_end_time, :regional_highlight => reg_highlight, :federal_highlight => fed_highlight, :sponsored => sponsored, :repeat_dates => formated_dates)
    
    replace_umlauts event
    
  end
  
  private
  
  def check_logged_in_user
    # first condition: logged in as user or admin,  second condition: edit foreign,  third condition: new, fourth condition: edit my own
    if (!current_user && !current_admin) || (current_user && !@event.title.empty? && current_user.id != @event.user_id && !current_user.federal_user && @event.user && !@event.user.regional_user) || (current_user && !@event.title.empty? && @event.user_id == nil) || (current_user && current_user.id != @event.user_id && !@event.title.empty? && !current_user.federal_user && @event.user && !@event.user.regional_user)
      redirect_to :root, :notice => 'Sie müssen sich einloggen, um Veranstaltungen hinzuzufügen, bearbeiten oder löschen zu können.'
    end
  end
  
  def replace_umlauts event
    event.description = event.description.gsub(/&Auml;/,'Ä')
    event.description = event.description.gsub(/&auml;/,'ä')
    event.description = event.description.gsub(/&Euml;/,'Ë')
    event.description = event.description.gsub(/&euml;/,'ë')
    event.description = event.description.gsub(/&Iuml;/,'Ï')
    event.description = event.description.gsub(/&iuml;/,'ï')
    event.description = event.description.gsub(/&Ouml;/,'Ö')
    event.description = event.description.gsub(/&ouml;/,'ö')
    event.description = event.description.gsub(/&Uuml;/,'Ü')
    event.description = event.description.gsub(/&uuml;/,'ü')
    event.description = event.description.gsub(/&Yuml;/,'Ÿ')
    event.description = event.description.gsub(/&yuml;/,'ÿ')
    event.save
  end
  
end
