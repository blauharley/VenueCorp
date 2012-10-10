class UserMailer < ActionMailer::Base
  
  def send_contact_mail user, sub, body
    if user.class != String
      @username = user.email
    else
      @username = user
    end
    
    @body = body
    mail(:to => 'xxtita@gmail.com', :from => @username, :subject => sub)
  end
  
end
