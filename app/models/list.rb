class List < ActiveRecord::Base
  has_many :items, dependent: :destroy
  validates :name, presence: true

  has_and_belongs_to_many :users
end
