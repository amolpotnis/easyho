class PatientFollowupsController < ApplicationController
  
  before_filter :signing_is_must, only: [:index, :new, :create]
  before_filter :owner_doctor_allowed, only: [:index, :new, :create]
  
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
  
  def create
    id = params[:patient_id]
    @patient_entry = Patient.find(id)
    
    @newfollowup = PatientFollowup.new
    @newfollowup.patient_id = @patient_entry.id
    @newfollowup.obseravations = params[:f_obs_editor] 
    @newfollowup.medicines = params[:f_med_editor]
        
    if @newfollowup.save
      logger.info("Created new followup entry for patient with id=" + @newpatient.id.to_s)
      redirect_to patient_path(@newpatient)
    else
      logger.error("Followup addition failed for patient with id=" + @newpatient.id.to_s)
      logger.error(@newfollowup.errors.full_messages)
      render 'new'
    end
  end
  
  #=========================================================================================
  #=========================================================================================
  private
    # TBD: Similra function is there in patinet controller too. Please clean it.
    def owner_doctor_allowed
      id = params[:patient_id]
      @patient_entry = Patient.find(id)
      if !current_user.nil? && current_user.isDoctor && current_user.id == @patient_entry.doctor_id
        # Great, everything is fine
      else
        flash[:notice] = 'You are not authorized to perform this operation.'
        redirect_to myopd_path
      end
    end
end
