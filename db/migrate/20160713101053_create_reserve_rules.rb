class CreateReserveRules < ActiveRecord::Migration[5.0]
  def change
    create_table :reserve_rules do |t|
      t.text :condition, null: false
      t.string :status, null: false, default: "inactive"
      t.timestamps
    end
  end
end
