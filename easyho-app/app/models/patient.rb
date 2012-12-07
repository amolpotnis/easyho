class Patient < ActiveRecord::Base
  attr_accessible :firstname, :lastname
  
  #Validations before saving  
  validates :firstname, presence: true
  validates :lastname, presence: true
  
  def to_param
    "#{id}-#{firstname.parameterize}-#{lastname.parameterize}"
  end
end
