class EventsController < ApplicationController
  
  before_filter :get_event_cats, :only => [:new, :edit]
  
  def index
    redirect_to :root, :notice => ''
  end
  
  def show
    @event = Event.find(params[:id])
  end
  
  def new
    @method = 'post'
    @event = Event.new(params[:event])
  end
  
  def create
    event = Event.new(params[:event])
    
    event_start_time = params[:event][:start_date] + ' ' + params[:event][:start_date_time]
    event_end_time = params[:event][:end_date] + ' ' + params[:event][:end_date_time]
    highlight = if params[:event][:highlight].to_i == 0 then false else true end
    
    event.update_attributes(:start_date_time => event_start_time, :end_date_time => event_end_time, :highlight => highlight)
    
    if event.save
      redirect_to :root, :notice => 'Veranstaltung erfolgreich hinzugefügt'
    else
      redirect_to :root, :notice => 'Veranstaltung konnte nicht angelegt werden'
    end
  end
  
  def edit
    @method = 'put'
    @event = Event.find(params[:id])
  end
  
  def update
    event = Event.find(params[:id])
    event_start_time = params[:event][:start_date] + ' ' + params[:event][:start_date_time]
    event_end_time = params[:event][:end_date] + ' ' + params[:event][:end_date_time]
    highlight = if params[:event][:highlight].to_i == 0 then false else true end
    
    event.update_attributes(:start_date_time => event_start_time, :end_date_time => event_end_time, :highlight => highlight)
    event.update_attributes(params[:event])
    
    redirect_to :root, :notice => 'Veranstaltung erfolgreich bearbeitet.'
  end
  
  def destroy
    Event.find(params[:id]).destroy
    redirect_to :root, :notice => 'Veranstaltung erfolgreich gelöscht.'
  end
  
  def upload_csv
    
    redirect_to :back, :notice => 'Zurzeit außer Betrieb!'
    return
    if params[:csv_file].content_type != 'text/csv'
      redirect_to :back, :notice => 'Datei: ' << params[:csv_file].original_filename << ' muss eine *.csv-Datei sein.'
      return
    end
    
    csv_file = params[:csv_file]
    csv_content_array = CSV.read(csv_file.open.path, col_sep: ";", encoding: "ISO8859-1")
    
    error_msg = 'Folgende Veranstaltungseinträge waren fehlerhaft: '
    row = 1
    error = false
    
    csv_content_array.each do |event|
      tmp_event = Event.create(:province => event[0], :region => event[1], :city => event[2], :main_category => event[3], :sub_category => event[4], :highlight => event[5], :venue => event[6], :start_date => event[7], :end_date => event[8], :start_date_time => event[9], :end_date_time => event[10], :photo_url => event[11], :title => event[12], :short_description => event[13], :long_description => event[14], :venue_url => event[15], :email => event[16], :tel_nr => event[17] )
      if !tmp_event.valid?
        error = true
        error_msg += ' in Zeile ' << row.to_s << ' Eintrag: ' << tmp_event.print_attr
      end
      row += 1
    end
    
    if error
      redirect_to :root, :notice => error_msg
    else
      redirect_to :root, :notice => 'Alle Einträge wurden erfolgreich in die Datenbank übernommen.'
    end
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
                             ['Highlight', event.highlight.to_s],
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
              image event.image.path, :position => :right, :vposition => 20, :width => 100, :height => 100
           end).path
    send_file( pdf_path, :type => 'application/pdf',:disposition => 'inline')
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
  
  def get_event_cats
    @main_event_cats = { 'Hauptkategorie' => '' }
    @main_event_cats = @main_event_cats.merge(Categories.get_main_cats)
    
    @event_cats  = []
    Categories.get_main_cats.each do |k,v|
      sub_cat = Categories.get_sub_cats k
      @event_cats << { k =>  sub_cat }
    end
  end
  
end
