class AddVeganColumnToFood < ActiveRecord::Migration[7.1]
  def change
    add_column :foods, :vegan, :boolean
  end
end
