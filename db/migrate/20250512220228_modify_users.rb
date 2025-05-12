class ModifyUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :username, :string
    remove_column :users, :address, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address_street, :string
    add_column :users, :address_building_number, :string
    add_column :users, :address_city, :string
    add_column :users, :address_state, :string
    add_column :users, :address_country, :string
  end
end
