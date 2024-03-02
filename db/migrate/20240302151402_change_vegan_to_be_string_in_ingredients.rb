class ChangeVeganToBeStringInIngredients < ActiveRecord::Migration[7.1]
  def change
    change_column :ingredients, :vegan, :string
  end
end
