﻿config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "http://event-corp.herokuapp.com/",
  :user_name            => "franz.josef.bruenner@aon.at",
  :password             => "ayduof3a",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

