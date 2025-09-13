class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :courier, null: true, foreign_key: true
      
      t.string :pickup_address
      t.float  :pickup_lat
      t.float  :pickup_lng

      t.string :dropoff_address
      t.float  :dropoff_lat
      t.float  :dropoff_lng

      t.string :package_size
      t.decimal :package_weight
      t.decimal :price
      t.integer :status

      t.timestamps
    end
  end
end
