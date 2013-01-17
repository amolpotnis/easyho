class PatientsController < ApplicationController
  before_filter :signing_is_must, only: [:new, :create, :list, :show]
    
  def sample
    render :template => "patients/sample", :formats => [:html], :handlers => :haml, :layout => "patientprofile"
  end
  
  def contact
    render :template => "patients/contact_info", :formats => [:html], :handlers => :haml
  end
  
  def new
    @newpatient = Patient.new
  end
  
  def show
    id = params[:id]
    @patient_entry = Patient.find(id) 
  end
  
  def list
    entries_per_page = 50
    #A doctor should be able to see only his patients.
    searchstr = params[:patientsearch]
    if(searchstr.nil? or searchstr.blank?)
      #normal listing  
      @patient_list = Patient.where("doctor_id = ?", current_user.id).order("opd_number DESC").page(params[:page]).per(entries_per_page)
    else    
      #search
      @patient_list = Patient.where("doctor_id = ? and ( opd_number like ? or firstname like ? or lastname like ?)", current_user.id, "%#{searchstr}%","%#{searchstr}%","%#{searchstr}%").order("opd_number DESC").page(params[:page]).per(entries_per_page)
    end
  end
  
  def search
    logger.debug("search test")
  end
  def create
    @newpatient = Patient.new(params[:patient])
    if current_user.isDoctor
      @newpatient.doctor_id = current_user.id
    end
    
    creation_err = false;  
    if @newpatient.save
      logger.info("Created new patient entry for user with firstname=" + @newpatient.firstname + " lastname=" + @newpatient.lastname + " id=" + @newpatient.id.to_s)
      #Save his opd id
      @newpatient.opd_number = "ON-" + @newpatient.doctor_id.to_s + "-" + @newpatient.id.to_s
      if @newpatient.save
        logger.info("Saved his OPD-number as " + @newpatient.opd_number)
        redirect_to patient_path(@newpatient)
      else
        logger.error("Problem while storing opd number:" + @newpatient.opd_number)
        creation_err = true  
      end
    else
      logger.error("Patient creation failed.")
      creation_err = true
    end
    
    if creation_err
      logger.error(@newpatient.errors.full_messages)
      render 'new'
    end
  end
end
