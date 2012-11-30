class MainUsersController < ApplicationController
  def new
    @mainuser = MainUser.new
    @signup = true
    render :template => "main_users/new", :formats => [:html], :handlers => :haml
  end
  
  def show
  end
end
