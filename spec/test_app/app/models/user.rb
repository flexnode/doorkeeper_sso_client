class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, password_length: 6..128

  has_one :passport, as: :identity, class_name: "DoorkeeperSsoClient::Passport"

  validates :email, :first_name, presence: true

end
