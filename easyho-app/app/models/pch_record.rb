class PchRecord < ActiveRecord::Base
  attr_accessible :patient_id, :pch_sec_id, :htmltext
end
