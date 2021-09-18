class Event < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :tickets, dependent: :destroy
  has_many :ticketed_users, through: :tickets, source: :user

  validates :title, presence: true, length: { in: 1..15 }
  validates :body, length: { maximum: 200 }
  validates :start_time, presence: true
  validate :limit_image

  def limit_image
    if image.attached?
      if !image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:image, 'にはjpegまたはpngファイルを添付してください')
      elsif image.blob.byte_size > 5.megabytes
        errors.add(:image, 'ファイルのサイズが大きすぎます。')
      end
    else
      errors.add(:image, 'ファイルを添付してください')
    end
  end  
  
  
end
