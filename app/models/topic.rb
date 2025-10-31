class Topic < ApplicationRecord
  belongs_to :image, optional: true
end
