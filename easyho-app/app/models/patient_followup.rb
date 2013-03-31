class PatientFollowup < ActiveRecord::Base
  attr_accessible :medicines, :observations, :patient_id
  
  belongs_to :patient
  
  #Validations before saving  
  validates :patient_id, presence: true
  validates :observations, presence: true
  validates :medicines, presence: true
end
