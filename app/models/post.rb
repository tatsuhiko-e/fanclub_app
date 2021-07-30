class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments

  validates :title, length: { in: 1..15 }   
  validates :body,  length: { in: 1..75 }        
  validate :limit_image

  def self.search(keyword)
    where(["title like? OR body like?", "%#{keyword}%", "%#{keyword}%"])
  end

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
