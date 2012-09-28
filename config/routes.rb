EventApp::Application.routes.draw do
  get "events/index"

  get "venue/index"
  
  resources :events
    match 'csvUpload' => 'Events#upload_csv', :as => 'csv_upload'
    match 'eventFeedRss/:ids' => 'Events#get_rss_feed', :as => 'event_feed'
    match 'allEventFeedRss' => 'Events#get_all_rss_feed', :as => 'all_event_feed'
    match 'getEventsByFormat/:attr/:value' => 'Events#get_events_by_format'
    match 'pdfEvent/:id' => 'Events#pdf_event', :as => 'pdf_event'
    
  controller :Venue do
    match 'eventHighlights/:highlight' => :index, :as => 'event_highlight'
    match 'catMainEvents/:cat' => :get_main_cat_events, :as => 'get_main_cat_events'
    match 'catSubEvents/:cat' => :get_sub_cat_events, :as => 'get_sub_cat_events'
    match 'earlyEvents' => :show_early_events, :as => 'early_events'
    match 'sendContactMail' => :send_contact_mail, :as => 'send_contact_mail'
  end
  
  controller :Ajax do
    match 'searchForEvents/:search' => :search_events
  end
  
  root :to => 'Venue#index'
  # See how all your routes lay out with "rake routes"

end
