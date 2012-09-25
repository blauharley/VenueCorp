class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def send_condact_mail
    @test = 'rejawik'
    mail(:to => 'franz.josef.bruenner@gmail.com', :subject => "Welcome to My Awesome Site")
  end
  
end
