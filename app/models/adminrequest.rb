class Adminrequest < ApplicationRecord
  validates :teamname, presence: true
  validates :twitter_url, presence: true
end
