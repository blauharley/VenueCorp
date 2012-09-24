﻿class EventsController < ApplicationController

  def index
    redirect_to :root, :notice => ''
  end
  
  def new
    @event = Event.new(params[:event])
  end
  
  def create
    event = Event.new(:province => params[:event][:province], :region => params[:event][:region], :city => params[:event][:city], :main_category => params[:event][:main_category], :sub_category => params[:event][:sub_category], :venue => params[:event][:venue], :start_date => params[:event][:start_date], :end_date => params[:event][:end_date], :photo_url => params[:event][:photo_url], :title => params[:event][:title], :description => params[:event][:description], :venue_url => params[:event][:venue_url], :email => params[:event][:email], :tel_nr => params[:event][:tel_nr] )
    
    event_start_time = params[:event][:start_date] + ' ' + params[:event][:start_date_time]
    event_end_time = params[:event][:end_date] + ' ' + params[:event][:end_date_time]
    highlight = if params[:event][:highlight].to_i == 0 then false else true end
    
    event.update_attributes(:start_date_time => event_start_time, :end_date_time => event_end_time, :highlight => highlight)
    
    if event.save
      redirect_to :root, :notice => event_start_time
    else
      redirect_to :root, :notice => 'Veranstaltung konnte nicht angelegt werden'
    end
  end
  
  def edit
    @event = Event.find(params[:id])
  end
  
  def update
    Event.find(params[:id]).update_attributes(params[:event])
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
  
end
