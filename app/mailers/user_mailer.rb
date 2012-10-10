class UserMailer < ActionMailer::Base
  default from: "franz.josef.bruenner@gmail.com"
  
  def send_contact_mail user, sub, body
    if current_user
      @username = current_user.email
    elsif current_admin
      @username = 'Admin'
    elsif !current_user && !current_admin
      @username = '(Nicht registriert!)'
    end
    
    @body = body
    mail(:to => 'xxtita@gmail.com', :subject => sub)
  end
  
end
