class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :omniauthable

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

  private
  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@email.com"
  end
end
