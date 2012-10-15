class RegistrationController < Devise::SessionsController
  before_filter :authenticate_as_admin
  
  def new
    if !current_admin
      redirect_to :root, :notice => 'Keine Berechtigung!'
    end
  end
  
  def create
    user = User.create! params[:user]
    if params[:userkind][:right] == 'federal_user'
      user.federal_user = true
      user.regional_user = false
    else
      user.federal_user = false
      user.regional_user = true
    end
    user.save!
    redirect_to :root, :notice => 'User erfolgreich angelegt!'
  end
  
  def edit
    @user = User.find(params[:format])
  end
  
  def update
    user = User.find(params[:user][:id])
    user.update_attributes params[:user]
    if params[:userkind][:right] == 'federal_user'
      user.federal_user = true
      user.regional_user = false
    else
      user.federal_user = false
      user.regional_user = true
    end
    user.save!
    redirect_to :root, :notice => 'User erfolgreich bearbeitet!'
  end
  
  def destroy
    User.find(params[:id]).destroy
    redirect_to :back, :notice => 'User erfolgreich gelöscht.'
  end
  
  private
  
  def authenticate_as_admin
    if !current_admin
      redirect_to :root, :notice => 'Keine Berechtigung!'
      return
    end
  end
  
end
