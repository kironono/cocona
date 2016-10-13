class AddTimestampColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :channel_services, :created_at, :datetime
    add_column :channel_services, :updated_at, :datetime

    add_column :channels, :created_at, :datetime
    add_column :channels, :updated_at, :datetime

    add_column :programs, :created_at, :datetime
    add_column :programs, :updated_at, :datetime

    add_column :resavations, :created_at, :datetime
    add_column :resavations, :updated_at, :datetime
  end
end
