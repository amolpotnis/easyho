class PatientsController < ApplicationController
  def sample
    render :template => "patients/sample", :formats => [:html], :handlers => :haml, :layout => "patientprofile"
  end
  
  def contact
    render :template => "patients/contact_info", :formats => [:html], :handlers => :haml
  end
end
