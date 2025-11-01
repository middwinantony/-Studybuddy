class Topic < ApplicationRecord
  belongs_to :image, optional: true
  has_one_attached :image
  validates :name, presence: true
  has_many :chats, dependent: :destroy
end
