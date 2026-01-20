class Topic < ApplicationRecord
  has_many_attached :images
  
  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
end
