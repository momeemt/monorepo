class Comment < ApplicationRecord
  belongs_to :user, :foreign_key => "user_id"
  #belongs_to :micropost, :foreign_key => "micropost_id"
  validates :user_id, presence: true
end
