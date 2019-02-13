class User < ApplicationRecord
  
  attr_accessor :remember_token

  #emails saved to db should be uniformly downcase, as they are used for login
  before_save { email.downcase! }
  #validates input
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, 
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  #provided by gem bcrypt
  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }

  class << self
    #method for creating user fixture for tests, thus using min_cost for password
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    #method creates token used for "remember me" function
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    #self is needed, in order to access object variable
    self.remember_token = User.new_token
    #bypasses authentification
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    #avoids bug in case user is logging out in one browser but still logged in in a second browser
    return false if remember_digest.nil?
    #checks remember_digest in db against remember_token in cookie
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
