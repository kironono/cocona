class CreateVideosTable < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :channel, null: false
      t.string :service_id, null: false
      t.string :service_name, null: false
      t.string :event_id, null: false
      t.string :title, null: false
      t.string :detail
      t.text :ext_detail
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.integer :duration, null: false
      t.text :video
      t.text :audio
      t.string :store_path, null: false
      t.timestamps
    end
  end
end
