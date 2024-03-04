class ChangeEnglishColumnInIngredients < ActiveRecord::Migration[7.1]
  def change
    rename_column :ingredients, :english, :english_name
  end
end
