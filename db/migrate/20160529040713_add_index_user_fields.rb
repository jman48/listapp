class AddIndexUserFields < ActiveRecord::Migration
  def change
    add_index :users, :id
    add_index :users, :email
    add_index :users, :username
    add_index :users, :user_id
  end
end
