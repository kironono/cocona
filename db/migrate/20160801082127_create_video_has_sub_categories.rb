class CreateVideoHasSubCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :video_has_sub_categories do |t|
      t.integer :video_id, null: false
      t.integer :sub_category_id, null: false
      t.timestamps

      t.index :video_id
      t.index :sub_category_id
    end
  end
end
