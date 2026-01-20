class Tag < ApplicationRecord
  belongs_to :micropost
  validates :micropost_id, presence: true
end
