class User < ApplicationRecord
  #when user is deleted, their posts should be deleted as well
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest

  
  #validates input
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, 
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  #provided by gem bcrypt
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  

  def password_reset_expired?
    # < meaning earlier than
    reset_sent_at < 2.hours.ago
  end

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

  def authenticated?(attribute, token)
    #send sends a msg to an object instance and its ancestors until a method responds 
    #(its name matches the first argument)
    #if no object is specified, sends to global object (@user)
    digest = send("#{attribute}_digest")
    #avoids bug in case user is logging out in one browser but still logged in in a second browser
    return false if digest.nil?
    #checks remember_digest in db against remember_token in cookie
    BCrypt::Password.new(digest).is_password?(token)
  end

  #activate an account
  def activate
=begin
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
=end
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #defines a proto-feed
  #see "Following users" for the full implementation
  #? guarantees escape in SQL statement
  def feed
    Micropost.where("user_id = ?", id)
    #equivalent to just writing "microposts"
  end


  private

    #all lower-case before saving/comparing to db
    def downcase_email
      self.email.downcase!
    end
  
    #creates and assigns activation token and digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
