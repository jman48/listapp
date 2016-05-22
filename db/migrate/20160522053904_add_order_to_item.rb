class AddOrderToItem < ActiveRecord::Migration
  def change
    add_column :items, :order, :integer, :default => 0
  end
end
