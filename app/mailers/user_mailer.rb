class UserMailer < ActionMailer::Base
  default from: "event-corp@events.com"
  
  def send_contact_mail sub, body
    @body = body
    mail(:to => 'franz.josef.bruenner@aon.at', :subject => sub)
  end
  
end
