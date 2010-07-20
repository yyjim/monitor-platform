require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation

  has_many :measure_datas ,:dependent=>:destroy
  has_many :qcms ,:dependent=>:destroy
  #has_many :weights ,:dependent=>:destroy
  has_many :blood_pressures,:dependent=>:destroy
  has_many :blood_sugars,:dependent=>:destroy
  
  # Create the user Measure Data in the database

  def create_measure_data(type,params)
    raise "data type is worng" if !MeasureData::ALLOW_TYPE.include?(type.classify)
    data = self.send(type.downcase.pluralize).new(params)
    data.save ? data : nil
  end

  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def enable_api!
     self.generate_api_key!
   end

   def disable_api!
     self.update_attribute(:api_key, "")
   end

   def api_is_enabled?
     !self.api_key.empty?
   end

   protected

     def secure_digest(*args)
       Digest::SHA1.hexdigest(args.flatten.join('--'))
     end

     def generate_api_key!
       self.update_attribute(:api_key, secure_digest(Time.now, (1..10).map{ rand.to_s }))
     end
    
    def make_activation_code
        self.activation_code = self.class.make_token
    end


end
