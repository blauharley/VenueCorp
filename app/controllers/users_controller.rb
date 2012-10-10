class UsersController < Devise::SessionsController
  before_filter :authenticate_user!, :only => [:new,:create]
  
  def new
  end
  
  def create
    current_user
    redirect_to :root
  end
  
  def destroy
    reset_session
    redirect_to :root
  end
  
end
