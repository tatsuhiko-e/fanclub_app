class Video < ApplicationRecord
  belongs_to :user

  
  validates :youtube_url, presence: true

end
