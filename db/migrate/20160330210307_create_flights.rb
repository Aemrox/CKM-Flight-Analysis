class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.string :year
      t.string :quarter
      t.string :month
      t.string :daym
      t.string :dayw
      t.string :date
      t.string :carrier
      t.string :tailnum
      t.string :flightnum
      t.string :origin
      t.string :o_city
      t.string :o_market
      t.string :o_state
      t.string :dest
      t.string :d_city
      t.string :d_market
      t.string :d_state
      t.string :departure_time
      t.string :actual_departure
      t.string :dep_delay
      t.string :dep_time_block
      t.string :taxiout
      t.string :wheels_off
      t.string :wheels_on
      t.string :taxi_in
      t.string :arrival_time
      t.string :actual_arrival
      t.string :arr_time_block
      t.string :cancelled
      t.string :cancel_code
      t.string :flight_time
      t.string :actual_time
      t.string :air_time
      t.string :flights
      t.string :distance
      t.string :carrier_delay
      t.string :weather_delay
      t.string :nas_delay
      t.string :security_delay
      t.string :late_aircraft_delay
      t.string :first_dep_time
      t.string :total_add_gtime
      t.string :longest_add_gtime

      t.timestamps null: false
    end
  end
end
