class Book < ApplicationRecord
  belongs_to :user
  
  validates :isbn, presence: true, length: { maximum: 255 }
  validates :title, presence: true, length: { maximum: 255 }
  validates :author, presence: true, length: { maximum: 255 }
  validates :status, numericality: { less_than: 3 }
end
