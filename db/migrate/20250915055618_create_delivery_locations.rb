class CreateDeliveryLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :delivery_locations do |t|
      t.references :order, null: false, foreign_key: true
      t.float :current_lat, null: false
      t.float :current_lng, null: false
      t.timestamps
    end
  end
end
