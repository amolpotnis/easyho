class MainUser < ActiveRecord::Base
  attr_accessible :firstname,:lastname, :mobile, :email, :password, :password_confirmation
  #Readymade method to provide us pwd related functionality
  has_secure_password
    
  #Store email addresses in lowecase
  before_save { |user| user.email = email.downcase }
  
  #Validations before saving  
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :mobile, presence: true
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
    
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  # -------------
  
end
