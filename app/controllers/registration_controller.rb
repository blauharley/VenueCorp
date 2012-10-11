class RegistrationController < Devise::SessionsController
  before_filter :authenticate_as_admin, :only => [:create]
  
  def new
    if !current_admin
      redirect_to :root, :notice => 'Keine Berechtigung!'
    end
  end
  
  def create
  end
  
  private
  
  def authenticate_as_admin
    if current_admin
      user = User.create! params[:user]
      user.save!
      redirect_to :root, :notice => 'User erfolgreich angelegt!'
    else
      redirect_to :root, :notice => 'Keine Berechtigung!'
    end
  end
end
