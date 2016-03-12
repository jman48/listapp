class CreateListsUsers < ActiveRecord::Migration
  def change
    create_table :lists_users do |t|
      t.references :list
      t.references :user
    end

    add_index :lists_users, [:list_id, :user_id]
    add_index :lists_users, :user_id
  end

  def down
    drop_table :lists_users
  end
end
