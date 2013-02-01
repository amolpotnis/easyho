require 'pch_section_util.rb'

class PatientsController < ApplicationController
  before_filter :signing_is_must, only: [:new, :create, :list, :show, :contact, :editcontact]
  before_filter :owner_doctor_allowed, only: [:contact, :editcontact]
    
  def sample
    render :template => "patients/sample", :formats => [:html], :handlers => :haml, :layout => "patientprofile"
  end
  
  def contact
    id = params[:id]
    @patient_entry = Patient.find(id)
    @age_in_words = ""
    if(!@patient_entry.dob.nil?)
      age = age_in_completed_years(@patient_entry.dob, Date.today)
      if(age > 0)
        @age_in_words = "(Current age: " + age.to_s + " years)"
      end
    end
    render :template => "patients/contact_info", :formats => [:html], :handlers => :haml
  end
  
  def editcontact
    id = params[:id]
    @patient_entry = Patient.find(id)
    render :template => "patients/edit_contact_info", :formats => [:html], :handlers => :haml
  end
  
  def update
    id = params[:id]
    dob_display = params[:patient1_dob]
    if !dob_display.nil? && dob_display.empty?
      params[:patient][:dob] = "" 
    end
    @patient_entry = Patient.find(id)
    
    if @patient_entry.update_attributes(params[:patient])
      flash[:notice] = "Successfully updated.".html_safe
      redirect_to contact_patient_path(@patient_entry)
    else
      #error TBD
    end
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


def casehistory
  id = params[:id]
  @patient_entry = Patient.find(id)
  if @patient_entry.nil?
    logger.debug("AMOL : NIL patient")
  end
  
  #Display sections and order
  @sec_display_info = pch_sections_list()
    
  #Actual data
  
  render :template => "patients/casehistory", :formats => [:html], :handlers => :haml, :layout => "patientprofile"
end

# ==========================================================================================
# ==========================================================================================
private
  def pch_sections_list()
    list_to_return = []
    pch_sections = PchSection.order("displayorder ASC")
    pch_sections.each do |sec_entry|
      tmp_obj = Pch_section_util.new
      tmp_obj.setSectionId(sec_entry.id)
      tmp_obj.setDisplayName(sec_entry.displayname)
      tmp_obj.setDisplayOrder(sec_entry.displayorder)
      list_to_return.push(tmp_obj)
    end
    return list_to_return
  end
  
  def owner_doctor_allowed
    id = params[:id]
    @patient_entry = Patient.find(id)
    if !current_user.nil? && current_user.isDoctor && current_user.id == @patient_entry.doctor_id
      # Great, everything is fine
    else
      flash[:notice] = 'You are not authorized to perform this operation.'
      redirect_to myopd_path
    end
  end
  
  def age_in_completed_years (bd, d)
      # Difference in years, less one if you have not had a birthday this year.
      a = d.year - bd.year
      a = a - 1 if (
           bd.month >  d.month or 
          (bd.month >= d.month and bd.day > d.day)
      )
      a
  end

end
