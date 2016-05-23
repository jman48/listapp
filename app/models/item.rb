class Item < ActiveRecord::Base
  belongs_to :list
  validates :name, presence: true
  validates :order, numericality: { only_integer: true, :greater_than_or_equal_to => 0 }
  before_validation :set_defaults

  private

  def set_defaults
    if !self.order
      self.order = 0
    end
  end
end
