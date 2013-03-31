class PatientFollowupsController < ApplicationController
  
  #to get list of followups for a patient
  def index
    id = params[:patient_id]
    @patient_entry = Patient.find(id)
    
    #Actual data
    @patient_followups = PatientFollowup.where("patient_id = ?", @patient_entry.id).order("created_at DESC")
    
    render :template => "patients/followups", :formats => [:html], :handlers => :haml
  end
  
  def new
    id = params[:patient_id]
    @patient_entry = Patient.find(id)
    @newfollowup = PatientFollowup.new
    render :template => "patients/newfollowup", :formats => [:html], :handlers => :haml
  end
  
end
