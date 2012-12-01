module SessionsHelper
  def sign_in(user, is_permanent)
    if is_permanent
      cookies.permanent[:remember_token] = user.remember_token
    else
      #local session
      session[:remember_token] = user.remember_token
    end
    self.current_user = user
  end
  
  #Set method
  def current_user=(user)
    @current_user = user
  end
  
  #get method
  def current_user
    token_to_use = session[:remember_token]
    if token_to_use.nil?
      token_to_use = cookies[:remember_token]
    end
    @current_user ||= MainUser.find_by_remember_token(token_to_use)
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    self.current_user = nil
    session.delete(:remember_token)
    cookies.delete(:remember_token)
  end
  
  def destroy
    sign_out
    redirect_to signin_path
  end
  
end
