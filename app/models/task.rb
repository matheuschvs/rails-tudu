class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: String
  field :title, type: String

  embedded_in :todo

  validates :title, presence: true, uniqueness: true
end
