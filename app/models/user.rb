class User < ActiveRecord::Base
  require "auth0"

  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true
  validates :email, email: true
  has_and_belongs_to_many :lists

  before_save :set_email

  def authenticate password
    provided_pass = BCrypt::Engine.hash_secret(password, self.salt)

    return provided_pass == self.password
  end

  #Return a user that is safe to use. e.g no password
  def safe_user
    user = {}

    user["email"] = self.email
    user["username"] = self.username

    return user
  end

  private

  def set_email
    self.email = self.email.downcase
  end

  def self.get_user user_id
    user = User.find_by user_id: user_id

    if !user
      logger.info "User not found in local DB. Getting user from auth0"

      auth0 = Auth0Client.new(
          :api_version => 2,
          :token => ENV['AUTH0_TOKEN'],
          :domain => "john.au.auth0.com"
      )

      auth0_user = auth0.user user_id

      user = User.create(
          user_id: auth0_user["user_id"],
          email: auth0_user["email"],
          username: auth0_user["name"]
      )
    end

    return user
  end
end
