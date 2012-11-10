class PatientsController < ApplicationController
  def sample
    render :template => "patients/sample", :formats => [:html], :handlers => :haml, :layout => "patientprofile"
  end
end
