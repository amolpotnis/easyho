class PchRecord < ActiveRecord::Base
  attr_accessible :patient_id, :pch_sec_id, :htmltext
  
  #Validations before saving  
  validates :patient_id, presence: true
  validates :pch_sec_id, presence: true
end
