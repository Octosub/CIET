class AddPreferencesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :preferences, :string
  end
end
