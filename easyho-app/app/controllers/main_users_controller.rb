class MainUsersController < ApplicationController
  def new
    @mainuser = MainUser.new
    @signup = true
    render :template => "main_users/new", :formats => [:html], :handlers => :haml
  end
  
  def show
  end
  
  def create
    @mainuser = MainUser.new(params[:main_user])
    #
    # TBD : Add more values to the user entry
    #
      
    if @mainuser.save
      logger.info("Created user entry for user with emailid=" + @mainuser.email)
      @signup = true
      redirect_to signupsuccess_path
    else
      logger.error("MainUser creation failed.")
      logger.error(@mainuser.errors.full_messages)
      flash[:error] = "Error while creating user for emailid=" + @mainuser.email 
      @signup = true
      render 'new' 
    end
  end
  
  def signupsuccess
    @signup = true
  end
end
