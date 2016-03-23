class User < ActiveRecord::Base
  validates :username, :password, :email, presence: true
  validates :username, :email, uniqueness: true
  validates :email, email: true
  has_and_belongs_to_many :lists

  before_save :secure_password

  def authenticate password
    provided_pass = BCrypt::Engine.hash_secret(password, self.salt)

    return provided_pass == self.password
  end

  private

  def secure_password
    self.salt = BCrypt::Engine.generate_salt
    self.password = BCrypt::Engine.hash_secret(self.password, salt)
  end
end
