class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  before_save { self.email = email.downcase }
  has_many :articles, dependent: :destroy
  has_one_attached :avatar
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 105}, format: { with: VALID_EMAIL_REGEX }
  validates :avatar, presence: true
  has_secure_password

  def get_avatar
    url_for(self.avatar)
  end

end
