class User < ActiveRecord::Base

  has_secure_password
  has_many :reviews
  has_many :addresses
  has_many :orders
  after_create :email_user

  validates_presence_of :firstname, :lastname, :email
  validates :email, uniqueness: true

  def email_user
    UserMailer.welcome_email(self).deliver
  end

end
