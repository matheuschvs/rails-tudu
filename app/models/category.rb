class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :color, type: String

  embedded_in :user
  has_many :todos, dependent: :delete_all

  validates :title, presence: true, uniqueness: true
  validates :color, presence: true, uniqueness: true
end
