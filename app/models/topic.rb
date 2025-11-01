class Topic < ApplicationRecord
  belongs_to :image, optional: true
  has_many :chats, dependent: :destroy
end
