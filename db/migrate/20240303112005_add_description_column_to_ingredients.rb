class AddDescriptionColumnToIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :english_description, :text
  end
end
