class MainUser < ActiveRecord::Base
  attr_accessible :firstname,:lastname, :mobile, :email, :password, :password_confirmation
  #Readymade method to provide us pwd related functionality
  has_secure_password
    
  #Store email addresses in lowecase
  before_save { |user| user.email = email.downcase }
  # Create unique token for each user ..will use for persistent sessions
  before_save :create_remember_token
  
  #Validations before saving  
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :mobile, presence: true
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
    
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  # -------------
  
  # For SEO friendly URLs
  def to_param
    "#{id}-#{firstname.parameterize}-#{lastname.parameterize}"
  end
  
  def isAdmin
    return self.isadmin ? true: false 
  end
  
  def isDoctor
    return self.isadmin ? false: true
  end
  
  def isAssistant
    return false
  end
  
  def isReceptionist
    return false
  end
  
  
  
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
  
end
