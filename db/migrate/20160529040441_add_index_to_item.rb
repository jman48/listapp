class AddIndexToItem < ActiveRecord::Migration
  def change
    add_index :items, :id
  end
end
