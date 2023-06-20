class User < ApplicationRecord
  has_secure_password
  validates :username, :email, :password, presence: true
  has_many :articles, dependent: :destroy
end
