class CreateTablePrograms < ActiveRecord::Migration[5.0]
  def change

    create_table :channels do |t|
      t.string :name, null: false
      t.string :channel, null: false
    end

    create_table :channel_services do |t|
      t.integer :channel_id, null: false
      t.string :service_id, null: false
      t.string :name, null: false
    end

    create_table :programs do |t|
      t.integer :channel_id, null: false
      t.integer :channel_service_id, null: false
      t.string :event_id, null: false
      t.string :title, null: false
      t.string :detail
      t.text :ext_detail
      t.datetime :start_at, null: false
      t.integer :duration, null: false
      t.string :large_category
      t.string :middle_category
      t.text :video
      t.text :audio
    end

  end
end
