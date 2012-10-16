class UsersController < Devise::SessionsController
  before_filter :authenticate_user!, :only => [:new,:create]
  before_filter :authenticate_admin!, :only => [:lock_user]
  
  def new
  end
  
  def create
    if current_user
      redirect_to :root, :notice => 'Erfolgreich eingeloggt!'
    else
      redirect_to :root, :notice => 'Login fehlgeschlagen!'
    end
  end
  
  def destroy
    reset_session
    redirect_to :root, :notice => 'Erfolgreich ausgeloggt!'
  end
  
  def lock_user
    
  end
  
end
