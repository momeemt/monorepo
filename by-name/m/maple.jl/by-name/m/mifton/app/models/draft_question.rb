class DraftQuestion < ApplicationRecord
  validates :title, presence: true;
end
