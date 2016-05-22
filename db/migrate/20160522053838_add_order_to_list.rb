class AddOrderToList < ActiveRecord::Migration
  def change
    add_column :lists, :order, :integer
  end
end
