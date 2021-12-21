class Contact < ApplicationRecord
  belongs_to :user

  validates :to_email, presence: true
  validates :message, presence: true, length: { in: 1..255 }
end
