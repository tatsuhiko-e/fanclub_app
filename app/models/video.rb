class Video < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { in: 1..20 }
  validates :youtube_url, presence: true
end
