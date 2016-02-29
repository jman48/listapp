class Item < ActiveRecord::Base
  belongs_to :lists
  validates :name, presence: true
end
