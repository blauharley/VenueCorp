# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
EventApp::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_USERNAME'],
  :password => ENV['SENDGRID_PASSWORD'],
  :domain => 'event-corp.herokuapp.com/',
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}