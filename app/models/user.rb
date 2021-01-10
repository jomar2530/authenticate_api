class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  def check_password(password)
    self.authenticate(password)
  end
end
