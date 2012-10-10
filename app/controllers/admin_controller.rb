class AdminController < Devise::SessionsController
  before_filter :authenticate_admin!, :only => [:new,:create]
  
  def new
  end
  
  def create
    current_admin
    redirect_to :root
  end
  
  def destroy
    reset_session
    redirect_to :root
  end
  
end
