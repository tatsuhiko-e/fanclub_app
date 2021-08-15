class Event < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :tickets
  has_many :ticketed_users, through: :tickets, source: :user
end
