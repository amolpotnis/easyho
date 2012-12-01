class SessionsController < ApplicationController
  def new
    @signinflag = true
  end
  
  def create
    #For default auth mechanism
    user = MainUser.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to root.
      sign_in(user, false)
      redirect_to myopd_path
      return
    else
      flash.now[:error] = 'Invalid email/password combination'
      @signinflag = true 
      render 'new'
      return
    end
  end
  
  def destroy
    sign_out
    redirect_to signin_path
  end
end
