class ChangeVegetarianAndAddColumnsToIngredients < ActiveRecord::Migration[7.1]
  def change
    change_column :ingredients, :vegetarian, :string
    add_column :ingredients, :pescetarian, :string
    add_column :ingredients, :dairy_free, :string
    add_column :ingredients, :peanut_free, :string
  end
end
