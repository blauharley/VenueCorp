class UserMailer < ActionMailer::Base
  default :from => "event-corp@heroku.com"
  
  def send_contact_mail user, sub, body
    if user.class != String
      @username = user.email
    else
      @username = user
    end
    
    @body = body
    mail(:to => 'xxtita@gmail.com', :subject => sub)
  end
  
end
