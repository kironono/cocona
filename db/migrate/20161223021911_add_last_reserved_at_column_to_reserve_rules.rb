class AddLastReservedAtColumnToReserveRules < ActiveRecord::Migration[5.0]
  def change
    add_column :reserve_rules, :last_reserved_at, :datetime
  end
end
