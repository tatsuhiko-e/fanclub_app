class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :omniauthable

  has_one_attached :image
  has_many :members, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :tickets
  has_many :ticket_events, through: :tickets, source: :event

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { in: 1..15 }
 
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

 
  # def active_for_authentication? 
  #   super && approved? 
  # end 
  
  # def inactive_message 
  #   approved? ? super : :not_approved
  # end

  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end

  def already_ticket?(event)
    self.tickets.exists?(event_id: event.id)
  end


  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
    
    unless user
      user = User.new(
        uid: auth.uid,
        provider: auth.provider,
        name: auth.info.name,
        email: auth.info.email ||= User.dummy_email(auth),
        password: Devise.friendly_token[0, 20]
      )

      user.skip_confirmation!
      user.save
    end

    user
  end


  enum area:{
    "---":0,
    北海道:1,青森県:2,岩手県:3,宮城県:4,秋田県:5,山形県:6,福島県:7,
    茨城県:8,栃木県:9,群馬県:10,埼玉県:11,千葉県:12,東京都:13,神奈川県:14,
    新潟県:15,富山県:16,石川県:17,福井県:18,山梨県:19,長野県:20,
    岐阜県:21,静岡県:22,愛知県:23,三重県:24,
    滋賀県:25,京都府:26,大阪府:27,兵庫県:28,奈良県:29,和歌山県:30,
    鳥取県:31,島根県:32,岡山県:33,広島県:34,山口県:35,
    徳島県:36,香川県:37,愛媛県:38,高知県:39,
    福岡県:40,佐賀県:41,長崎県:42,熊本県:43,大分県:44,宮崎県:45,鹿児島県:46,
    沖縄県:47
  }

  enum gender: { 男: 0, 女: 1}


  private
  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@email.com"
  end

end
