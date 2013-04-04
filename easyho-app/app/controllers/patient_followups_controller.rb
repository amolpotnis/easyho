class PatientFollowupsController < ApplicationController
  
  before_filter :signing_is_must, only: [:index, :new, :create]
  before_filter :owner_doctor_allowed, only: [:index, :new, :create]
  
  #to get list of followups for a patient
  def index
    id = params[:patient_id]
    @patient_entry = Patient.find(id)
    
    #Actual data
    @patient_followups = PatientFollowup.where("patient_id = ?", @patient_entry.id).order("created_at DESC")
    
    @currow = params[:currow]
    
    render :template => "patient_followups/followups", :formats => [:html], :handlers => :haml
  end
  
  def new
    id = params[:patient_id]
    @patient_entry = Patient.find(id)
    @patient_followup = PatientFollowup.new
    render :template => "patient_followups/newfollowup", :formats => [:html], :handlers => :haml
  end
  
  def create
    id = params[:patient_id]
    @patient_entry = Patient.find(id)
    
    @patient_followup = PatientFollowup.new
    @patient_followup.patient_id = @patient_entry.id
    @patient_followup.observations = params[:f_obs_editor] 
    @patient_followup.medicines = params[:f_med_editor]
        
    if @patient_followup.save
      logger.info("Created new followup entry for patient with id=" + @patient_entry.id.to_s)
      redirect_to patient_patient_followups_path(@patient_entry)+"?currow=#{@patient_followup.id}"
    else
      logger.error("Followup addition failed for patient with id=" + @patient_entry.id.to_s)
      logger.error(@patient_followup.errors.full_messages)
      render 'newfollowup'
    end
  end
  
  def edit
    patient_id = params[:patient_id]
    @patient_entry = Patient.find(patient_id)
    
    id = params[:id]
    @patient_followup = PatientFollowup.find(id)
    
    #render :template => "editfollowup", :formats => [:html], :handlers => :haml
  end
  
  def update
    
    patient_id = params[:patient_id]
    @patient_entry = Patient.find(patient_id)
    
    id = params[:id]
    @patient_followup = PatientFollowup.find(id)
    
    @patient_followup.observations = params[:f_obs_editor]
    @patient_followup.medicines = params[:f_med_editor]
      
    if @patient_followup.save
      flash[:notice] = "Successfully updated.".html_safe
      redirect_to patient_patient_followups_path(@patient_entry)+"?currow=#{@patient_followup.id}"
    else
      logger.error(@patient_followup.errors.full_messages)
      render 'edit'
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
