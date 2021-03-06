EventApp::Application.routes.draw do
  
  mount Ckeditor::Engine => "/ckeditor"
  
  get "admin/new"

  get "admin/create"

  devise_for :admins, :controllers => { :sessions => "admin" }

  get "registration/new"

  devise_for :users, :controllers => { :sessions => "users", :registrations => "registration" }

  resources :events
    match 'eventFeedRss/:ids' => 'Events#get_rss_feed', :as => 'event_feed'
    match 'allEventFeedRss' => 'Events#get_all_rss_feed', :as => 'all_event_feed'
    match 'getEventsByFormat/:attr/:value' => 'Events#get_events_by_format'
    match 'pdfEvent/:id' => 'Events#pdf_event', :as => 'pdf_event'
    match 'pdfEvents/:ids' => 'Events#pdf_events', :as => 'pdf_events'
    match 'icsEvent/:id' => 'Events#ics_event', :as => 'ics_event'
    
  get "venue/index"
  
  controller :Venue do
    match 'eventHighlights/:cat/:highlight' => :index, :as => 'event_highlight'
    match 'federalCountry/:country' => :get_federal_country, :as => 'get_federal_country'
    match 'venue/:city' => :get_venue, :as => 'get_venue'
    match 'catMainEvents/:cat' => :get_main_cat_events, :as => 'get_main_cat_events'
    match 'catSubEvents/:cat' => :get_sub_cat_events, :as => 'get_sub_cat_events'
    match 'date/:start_date' => :get_events_by_date
    match 'contact' => :contact, :as => 'contact'
    match 'sendContactMail' => :send_contact_mail, :as => 'send_contact_mail'
    match 'searchSurroundingEvents' => :search_surrounding_events, :as => 'search_surrounding_events'
    match 'locationSearch' => :get_events_by_geocoding, :as => 'get_events_by_geocoding'
    match 'userlist' => :get_user_list, :as => 'get_user_list'
    match 'sitemap.xml' => :sitemap
  end
  
  controller :Ajax do
    match 'searchForEvents/:search' => :search_events
  end
  
  root :to => 'Venue#index'
  # See how all your routes lay out with "rake routes"

end
