class RegistrationController < Devise::SessionsController
  def new
  end
  
  def create
    user = User.create! params[:user]
    user.save!
    redirect_to :root
  end
end
