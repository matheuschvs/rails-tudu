class Todo
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :deadline, type: Date
  field :status, type: String

  belongs_to :owner, class_name: "User", inverse_of: :todos
  belongs_to :category
  has_and_belongs_to_many :members, class_name: "User", inverse_of: nil
  embeds_many :tasks
  embeds_many :comments

  validates :title, presence: true
  validates :deadline, presence: true
  validates :category, presence: true, on: :create
end
