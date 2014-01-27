class User < ActiveRecord::Base
  has_secure_password
  has_many :builds

  validate :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
end
