class User < ApplicationRecord
  attr_accessor :activate_now

  pay_customer 
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save :downcase_email

  has_one :permission, dependent: :destroy
  has_many :membership_users, dependent: :destroy
  has_many :memberships, through: :membership_users
  has_many :flights
  has_many :reservations
  has_many :flights, through: :reservations
  has_many :aircraft_users
  has_many :aircrafts, through: :aircraft_users
  validates :username, presence: true, 
                      uniqueness: { case_sensitive: false }, 
                      length: { minimum: 3, maximum: 25 }
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, presence: true, length: { maximum: 105 },
                      uniqueness: { case_sensitive: false }, 
                      format: { with: VALID_EMAIL_REGEX }  
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

# Sets the activation reset attributes.
def refresh_activation_digest
  self.activation_token = User.new_token
  update_attribute(:activation_digest,  User.digest(activation_token))
end

   # Sends activation email.
   def resend_activation_email

    UserMailer.resend_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  
  # returns a string of all aircraft that the user has reservation privileges in
  # this is of limited usefulness but prints the data in the AircraftUser table in a visual way
  def privileges_in
    
    # will need to limit this to users that have active memberships once available
    aircraftuser_ids = AircraftUser.where(user_id: User.where(id: self.id).ids)
      privileges_in = []
      aircraftuser_ids.each do |aircraftuser_id|
        privileges_in << { id: AircraftUser.find(aircraftuser_id.id).aircraft.id, short_name: AircraftUser.find(aircraftuser_id.id).aircraft.short_name }
      end
    return privileges_in

  end

  def stripe_attributes(pay_customer)
    {
      address: {
        city: pay_customer.owner.city,
        country: pay_customer.owner.country
      },
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id # or pay_customer.owner_id
      }
    }
  end

  #sync user info with payment info
  def pay_should_sync_customer?
    # super will invoke Pay's default (e-mail changed)
    # super || self.saved_change_to_address? || self.saved_change_to_name?
  end




  private

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  
  

end
