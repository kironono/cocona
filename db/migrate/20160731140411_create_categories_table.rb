class CreateCategoriesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :main_categories do |t|
      t.string :name, null: false
      t.timestamps

      t.index :name, unique: true
    end

    create_table :sub_categories do |t|
      t.string :name, null: false
      t.integer :main_category_id, null: false
      t.timestamps

      t.index :name
      t.index :main_category_id
      t.index [:name, :main_category_id], unique: true
    end

    create_table :program_has_sub_categories do |t|
      t.integer :program_id, null: false
      t.integer :sub_category_id, null: false
      t.timestamps

      t.index :program_id
      t.index :sub_category_id
    end
  end
end
