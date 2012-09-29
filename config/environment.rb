# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
EventApp::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => "franz.josef.bruenner@gmail.com",
  :password             => "ayduof3a",
  :authentication       => 'plain'
}