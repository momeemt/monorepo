class Micropost < ApplicationRecord
  has_many_attached :images

  belongs_to :user
  validates :user_id, presence: true

  has_many :tags, dependent: :destroy

  default_scope -> { order(created_at: :desc) }

  validates :content, presence: true, length: { in: 1..140 }
end
