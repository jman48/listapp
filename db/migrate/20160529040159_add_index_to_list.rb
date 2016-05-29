class AddIndexToList < ActiveRecord::Migration
  def change
    add_index :lists, :id
  end
end
