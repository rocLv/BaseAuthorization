class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'       
  attr_accessor :login
  validates :name, :uniqueness => { :case_sensitive => false }
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", 
                                   { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
end


