class DraftMicropost < ApplicationRecord
  has_many_attached :images

  belongs_to :user
  validates :user_id, presence: true

  default_scope -> { order(created_at: :desc) }

  validates :content, presence: true, length: { in: 1..140 }
end
