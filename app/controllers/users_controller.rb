class UsersController < Devise::SessionsController
  before_filter :authenticate_user!
  
  def index
    redirect_to :root
  end
  
  def new
    #redirect_to :root
  end
  
  def create
    current_user
    redirect_to :root
  end
  
  def destroy
    current_user.destroy
    redirect_to :root
  end
  
end
