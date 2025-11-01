class Topic < ApplicationRecord
  belongs_to :image, optional: true
  has_one_attached :image
  validates :name, presence: true
end
