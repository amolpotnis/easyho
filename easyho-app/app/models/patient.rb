class Patient < ActiveRecord::Base
  attr_accessible :firstname, :lastname, :middlename, :email, :mobile, :homeaddress, :homephone, :dob, :jobphone, :jobemail, :jobaddress, :jobdescription
  
  #Validations before saving  
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :doctor_id, presence: true
  
  def to_param
    "#{id}-#{firstname.parameterize}-#{lastname.parameterize}"
  end
end
