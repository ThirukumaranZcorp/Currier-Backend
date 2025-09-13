class CreateCouriers < ActiveRecord::Migration[8.0]
  def change
    create_table :couriers do |t|
      t.string :name
      t.string :service_type # "Express", "Economy"
      t.decimal :base_price, precision: 10, scale: 2
      t.decimal :price_per_km, precision: 10, scale: 2
      t.timestamps
    end
  end
end
