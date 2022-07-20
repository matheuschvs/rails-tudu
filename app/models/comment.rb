class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :comment, type: String
  field :user, type: String

  embedded_in :todo

  validates :comment, presence: true
end
