class ChangeVeganToBeStringInFoods < ActiveRecord::Migration[7.1]
  def change
    change_column :foods, :vegan, :string
  end
end
