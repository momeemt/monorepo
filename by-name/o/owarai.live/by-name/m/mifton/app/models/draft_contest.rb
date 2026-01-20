class DraftContest < ApplicationRecord
  validates :name, presence: true
end
