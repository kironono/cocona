class ChangeResavationsType < ActiveRecord::Migration[5.0]
  def change
    rename_column :resavations, :type, :reserve_method
  end
end
