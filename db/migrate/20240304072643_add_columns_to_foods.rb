class AddColumnsToFoods < ActiveRecord::Migration[7.1]
  def change
    add_column :foods, :vegetarian, :string
    add_column :foods, :pescetarian, :string
    add_column :foods, :dairy_free, :string
    add_column :foods, :peanut_free, :string
  end
end
