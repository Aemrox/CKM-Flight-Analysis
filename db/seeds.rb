require 'csv'

Flight.delete_all

test_file = CSV.read('db/full_data.csv')

puts "The size of the file is #{test_file.length} rows long"

test_file.each do |entry|
  if entry[17] == "New York City, NY (Metropolitan Area)" || entry[12] == "New York City, NY (Metropolitan Area)"
    f = Flight.new
    f.year = entry[1]
    f.quarter = entry[2]
    f.month = entry[3]
    f.daym = entry[4]
    f.dayw = entry[5]
    f.date = entry[6]
    f.carrier = entry[7]
    f.tailnum = entry[8]
    f.flightnum = entry[9]
    f.origin = entry[10]
    f.o_city = entry[11]
    f.o_market = entry[12]
    f.o_state = entry[13]
    f.dest = entry[15]
    f.d_city = entry[16]
    f.d_market = entry[17]
    f.d_state = entry[18]
    f.departure_time = entry[20]
    f.actual_departure = entry[21]
    f.dep_delay = entry[22]
    f.dep_time_block = entry[23]
    f.taxiout = entry[24]
    f.wheels_off = entry[25]
    f.wheels_on = entry[26]
    f.taxi_in = entry[27]
    f.arrival_time = entry[28]
    f.actual_arrival = entry[29]
    f.arr_time_block = entry[30]
    f.cancelled = entry[32]
    f.cancel_code = entry[33]
    f.flight_time = entry[34]
    f.actual_time = entry[35]
    f.air_time = entry[36]
    f.flights = entry[37]
    f.distance = entry[38]
    f.carrier_delay = entry[39]
    f.weather_delay = entry[40]
    f.nas_delay = entry[41]
    f.security_delay = entry[42]
    f.late_aircraft_delay = entry[43]
    f.first_dep_time = entry[44]
    f.total_add_gtime = entry[45]
    f.longest_add_gtime = entry[46]
    f.save!
  end
end

puts "The number of flights is #{Flight.all.length}"
