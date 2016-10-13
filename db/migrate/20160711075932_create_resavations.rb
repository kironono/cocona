class CreateResavations < ActiveRecord::Migration[5.0]
  def change
    create_table :resavations do |t|
      t.integer :program_id, null: false
      t.string :type, null: false, default: "auto"
      t.string :status, null: false, default: "reserved"
    end
  end
end
