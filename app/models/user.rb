class User < ActiveRecord::Base
  validates :username, :password, presence: true
  validates :username, uniqueness: true

  before_save :secure_password

  def secure_password
    self.salt = BCrypt::Engine.generate_salt
    self.password = BCrypt::Engine.hash_secret(self.password, salt)
  end

  def authenticate password
    provided_pass = BCrypt::Engine.hash_secret(password, self.salt)

    return provided_pass == self.password
  end
end
