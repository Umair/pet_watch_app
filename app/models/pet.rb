class Pet < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :breed, presence: true
  validates :age, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 30 }
end
