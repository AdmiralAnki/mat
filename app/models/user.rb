class User < ApplicationRecord
	#has_secure_password

  #before_save :encrypt_password
  #before_save :bool_field
  def encrypt_password
       if password.present?
         self.password_digest = BCrypt::Engine.generate_salt
         self.password= BCrypt::Engine.hash_secret(password,password_digest)
       end
   end
    
  validates :age, numericality: { greater_than_or_equal_to: 18}
 # validates_format_of :password, :with => /(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,20}/
  #validates :password, presence: true, confirmation: true
  #validates :password_confirmation, presence: true
  validates :phone, length: { is: 10 }, numericality: { only_integer: true}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,presence: true, format: { with: VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
  validates :name,:age,:current_job,:qualification,:religion, presence: true
  def self.authenticate(email, password)
	  user = find_by_email(email)
	  if user && user.password == password
	  	if user.status==true

	  	#BCrypt::Engine.hash_secret(password, user.password_digest)
	  	user
	    else
	  	  nil
	  	 end
	  else
	  	nil
	  end
  end
end