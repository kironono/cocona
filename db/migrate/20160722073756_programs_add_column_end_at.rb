class ProgramsAddColumnEndAt < ActiveRecord::Migration[5.0]
  def up
    add_column :programs, :end_at, :datetime, null: false
  end

  def down
    remove_column :programs, :end_at
  end
end
