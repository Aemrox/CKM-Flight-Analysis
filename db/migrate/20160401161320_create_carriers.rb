class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :name
      t.string :destinations
      t.integer :flights
      t.integer :cancellations
      t.integer :total_taxi_in
      t.integer :total_taxi_out
      t.integer :total_arr_delay
      t.integer :total_dep_delay
      t.integer :carrier_delay
      t.integer :late_aircraft_delay
      t.integer :weather_delay

      t.timestamps null: false
    end
  end
end
