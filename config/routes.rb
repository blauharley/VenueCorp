EventApp::Application.routes.draw do
  get "events/index"

  get "venue/index"
  
  resources :events
    match 'csv_upload' => 'Events#upload_csv', :as => 'csv_upload'
    match 'eventFeedRss/:ids' => 'Events#get_rss_feed', :as => 'event_feed'
    match 'allEventFeedRss' => 'Events#get_all_rss_feed', :as => 'all_event_feed'
    match 'getEventsByFormat/:attr/:value' => 'Events#get_events_by_format'
    match 'pdf_event/:id' => 'Events#pdf_event', :as => 'pdf_event'
    
  controller :Venue do
    match 'event_highlight/:highlight' => :index, :as => 'event_highlight'
    match 'earlyEvents' => :show_early_events, :as => 'early_events'
    match 'placeEvents' => :show_place_events, :as => 'place_events'
    match 'groupEvents' => :show_group_events, :as => 'group_events'
  end
  
  root :to => 'Venue#index'
  # See how all your routes lay out with "rake routes"

end
