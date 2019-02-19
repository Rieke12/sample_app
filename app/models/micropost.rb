class Micropost < ApplicationRecord
  belongs_to :user
  #stabby lambda!
  default_scope -> { order(created_at: :desc) }

  #validation is tested in test/models/microposts
  #a user should exist and be present
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
