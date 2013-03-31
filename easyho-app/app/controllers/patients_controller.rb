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
    @patient_entry = Patient.find(id)
    
    if !params[:from_ch_edit].nil? && params[:from_ch_edit] == "true"
      # Update case history case
      content_to_save = params["sec_editor"]
      section_id = params["sec_id"]
        
      @needed_pch_record = PchRecord.new
      pch_rec_set = PchRecord.where("patient_id = ? and pch_sec_id = ?",@patient_entry.id, section_id)
      if pch_rec_set.nil? || pch_rec_set.length == 0
        #Need to create one.
        logger.debug("AMOL: new record")
        #needed_pch_record = PchRecord.new
        @needed_pch_record.patient_id = @patient_entry.id
        @needed_pch_record.pch_sec_id = section_id
      else
        #We'll update this
        @needed_pch_record = pch_rec_set[0]
        logger.debug("AMOL: existing record")
      end
      @needed_pch_record.htmltext = content_to_save
      if @needed_pch_record.save
        logger.debug("AMOL: saved")
      else
        logger.debug("AMOL: save error")
      end
      respond_to do |format|
        format.js { render :template => "patients/pch_update", :formats => [:js],
                        :handlers => :haml}
      end  
    else
      #
      # Update contact info
      # 
      dob_display = params[:patient1_dob]
      if !dob_display.nil? && dob_display.empty?
        params[:patient][:dob] = "" 
      end
      
      if @patient_entry.update_attributes(params[:patient])
        flash[:notice] = "Successfully updated.".html_safe
        redirect_to contact_patient_path(@patient_entry)
      else
        #error TBD
      end
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
  @pch_records = PchRecord.where("patient_id = ?", @patient_entry.id)
  @pch_hash = {}
  @pch_records.each do |each_record|
    @pch_hash[each_record.pch_sec_id] = each_record.htmltext
    logger.debug("secid= #{each_record.pch_sec_id}  htmltext=#{each_record.htmltext}")
  end
  
  render :template => "patients/casehistory", :formats => [:html], :handlers => :haml, :layout => "patientprofile"
end

#Edit case history
def editch
  id = params[:id]
  @patient_entry = Patient.find(id)
  @select_secid = params[:sec]
    
  #Display sections and order
  @sec_display_info = pch_sections_list()
  
  firstSecId = @sec_display_info[0].getSectionId
  logger.debug("firstsecid= #{firstSecId}")
  if @select_secid.nil? || @select_secid == "" 
    @select_secid = firstSecId
  end
  logger.debug("Selectsecid= #{@select_secid}")
  
  #get content for the selected section
  @current_pch_sec_html_content = nil
  pch_records = PchRecord.where("patient_id = ? and pch_sec_id = ?", @patient_entry.id,@select_secid )
  if(!pch_records.nil? && !pch_records[0].nil?)
    @current_pch_sec_html_content = pch_records[0].htmltext
  end
  
  render :template => "patients/edit_casehistory", :formats => [:html], :handlers => :haml
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
