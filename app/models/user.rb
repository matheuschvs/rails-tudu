class User
  include ActiveModel::SecurePassword
  include Mongoid::Document
  include Mongoid::Timestamps

  has_secure_password

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String

  embeds_many :categories
  has_many :todos, inverse_of: :owner

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true
end
