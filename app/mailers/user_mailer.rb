class UserMailer < ActionMailer::Base
  default from: "event-corp@events.com"
  
  def send_contact_mail sub, body
    mail(:body => body, :to => 'franz.josef.bruenner@gmail.com', :subject => sub)
  end
  
end
