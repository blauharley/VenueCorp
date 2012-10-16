class UsersController < Devise::SessionsController
  before_filter :authenticate_user!, :only => [:new,:create]
  
  def new
  end
  
  def create
    if current_user && !current_user.locked
      redirect_to :root, :notice => 'Erfolgreich eingeloggt!'
    else
      reset_session
      redirect_to :root, :notice => 'Login fehlgeschlagen!'
    end
  end
  
  def destroy
    reset_session
    redirect_to :root, :notice => 'Erfolgreich ausgeloggt!'
  end
  
end
