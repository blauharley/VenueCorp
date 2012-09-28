class AjaxController < ApplicationController
  
  def search_events
    @events = Event.search(params[:search])
    render "search_events", :layout => false
  end
  
end
