class AddOrderToList < ActiveRecord::Migration
  def change
    add_column :lists, :order, :integer, :default => 0
  end
end
