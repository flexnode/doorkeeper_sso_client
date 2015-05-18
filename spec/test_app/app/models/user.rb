class User < ActiveRecord::Base

  has_one :passport, as: :identity

  validates :email, :first_name, presence: true

end
