class User < ActiveRecord::Base
  require "auth0"

  validates :username, :email, :user_id, presence: true
  validates :username, :user_id, uniqueness: true
  validates :email, email: true
  has_and_belongs_to_many :lists

  before_save :set_email

  #Return a user that is safe to use. e.g no password
  def safe_user
    {:username => self.username, :picture => self.picture, :id => self.id}
  end

  #Get a user based on auth0 user id.
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
      username = User.get_unique_username auth0_user["nickname"]

      user = User.create(
          user_id: auth0_user["user_id"],
          email: auth0_user["email"],
          username: username.downcase
      )
    end

    return user
  end

  private

  def set_email
    self.email = self.email.downcase
  end

  #Returns a unique username when given a username when compared with local DB users table
  def self.get_unique_username username
    unique = false
    username_unique = username
    count = 0

    while !unique
      if User.find_by(username: username_unique)
        username_unique = username + count.to_s
        count += 1
      else
        unique = true
      end
    end

    return username_unique
  end
end
