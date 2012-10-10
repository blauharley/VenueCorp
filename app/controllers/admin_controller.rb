class AdminController < Devise::SessionsController
  before_filter :authenticate_admin!, :only => [:new,:create]
  
  def new
  end
  
  def create
    if current_admin
      redirect_to :root, :notice => 'Erfolgreich eingeloggt!'
    else
      redirect_to :root, :notice => 'Login fehlgeschlagen!'
    end
  end
  
  def destroy
    reset_session
    redirect_to :root, :notice => 'Erfolgreich ausgeloggt!'
  end
  
end
