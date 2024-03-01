class AddVeganColumToIngredient < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :vegan, :boolean
  end
end
