class Event < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  
end
