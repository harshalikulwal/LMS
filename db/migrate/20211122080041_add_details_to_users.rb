class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :manager_id, :integer
    add_column :users, :role_id, :integer
    add_column :users, :salary, :integer
  end
end
