class AddEnglishColumToIngredient < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :english, :string
  end
end
