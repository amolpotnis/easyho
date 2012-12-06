class SessionsController < ApplicationController
  def new
    @signinflag = true
  end
  
  def create
    #For default auth mechanism
    user = MainUser.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to root.
      remember_flag = false
      remember_flag_val = params[:remember_me]
      if !remember_flag_val.nil? 
        logger.debug ("remember_flag_val = " + remember_flag_val.to_s)
      end
      if !remember_flag_val.nil? && remember_flag_val == "1"
        remember_flag = true 
      end
      
      sign_in(user, remember_flag)
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
