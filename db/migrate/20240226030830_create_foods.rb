class CreateFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :foods do |t|
      t.string :name
      t.string :ingredient_list
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
