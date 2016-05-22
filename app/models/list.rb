class List < ActiveRecord::Base
  has_many :items, dependent: :destroy
  validates :name, presence: true
  validates :order, numericality: { only_integer: true, :greater_than_or_equal_to => 0 }

  has_and_belongs_to_many :users
end
