class ChangeTableReservations < ActiveRecord::Migration[5.0]
  def change
    rename_table :resavations, :reservations
  end
end
