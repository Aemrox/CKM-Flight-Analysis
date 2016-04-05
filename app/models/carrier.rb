class Carrier < ActiveRecord::Base

#CONSTANTS
  RED = {
    r:	255,
    g: 0,
    b: 0
  }
  GREEN = {
    r:	0,
    g: 255,
    b: 0
  }

  BENCHMARKS = {
    cancellation_rate: 5.68, #1.59
    avg_departure_delay: 8.85, #6.44
    avg_taxi_out: 23.20, #14.91
    avg_arrival_delay: 2.12, #1.98
    avg_taxi_in: 6.84, #6.70
    std_dev_departure_delay: 34.67,
    std_dev_arrival_delay: 39.09,
    late_departure_rate: 26.90,
    late_arrival_rate: 29.57,
    early_arrival_rate: 64.77
  }

  ST_DEV = {
    :cancellation_rate=>2.2676,
    :avg_departure_delay=>4.0512,
    :avg_taxi_out=>7.55,
    :avg_arrival_delay=>5.3924,
    :avg_taxi_in=>2.476,
    :std_dev_departure_delay=>20.8923,
    :std_dev_arrival_delay=>19.7454,
    :late_departure_rate=>10.0182,
    :late_arrival_rate=>10.8362,
    :early_arrival_rate=>19.965
  }

  SMART_SCORE_BREAKDOWN ={
    cancellation_rate: 10, #1.59
    avg_departure_delay: 8, #6.44
    avg_taxi_out: 4, #14.91
    avg_arrival_delay: 12, #1.98
    avg_taxi_in: 6, #6.70
    std_dev_departure_delay: 4,
    std_dev_arrival_delay: 6,
    late_departure_rate: 8,
    late_arrival_rate: 6,
    early_arrival_rate: 6,
  }

  SMART_SCORE_RUBRIC ={
    number_of_flights: 10,
    number_of_destinations: 10,
    rating: 10,
    cancellation_rate: 10, #1.59
    average_departure_delay: 8, #6.44
    average_taxi_out: 4, #14.91
    average_arrival_delay: 12, #1.98
    average_taxi_in: 6, #6.70
    standard_deviation_of_departure_delay: 4,
    standard_deviation_of_arrival_delay: 6,
    late_departure_rate: 8,
    late_arrival_rate: 6,
    early_arrival_rate: 6,
  }

  RATING = {
    "AirTran Airways Corporation" => 3,
    "Alaska Airlines Inc." => 6,
    "American Airlines Inc." => 3,
    "Delta Air Lines Inc." => 5,
    "ExpressJet Airlines Inc." => 3,
    "Frontier Airlines Inc." => 2,
    "Hawaiian Airlines Inc." =>5,
    "JetBlue Airways" => 6,
    "Mesa Airlines Inc." => 3,
    "SkyWest Airlines Co." => 7,
    "Southwest Airlines Co." => 6,
    "United Air Lines Inc." => 3,
    "US Airways Inc." => 3,
    "Virgin America" => 7
  }

#Critical Data
  def self.destination_search(search_city)
    d_hash = {}
    Carrier.all.each do |carrier|
      carrier_hash = carrier.destination_hash
      carrier_hash.each do |city, flights|
        if city == search_city
          d_hash[carrier.id] = flights
        end
      end
    end
    d_hash
  end

  def destination_hash
    d_hash = {}
    all_d = destinations.split("--")
    i = 0
    while i < all_d.length do
      d_hash[all_d[i]] = all_d[i+1]
      i += 2
    end
    d_hash
  end

  def rating_color
    color = gradient_color(rating/10.0)
    [rating, color]
  end

  def flights_color
    percent = [flights/20000.0, 1].min
    color = gradient_color(percent)
    [flights, color]
  end

  def destinations_color
    destinations = destination_hash.keys.length
    percent = [destinations/25.0, 1].min
    color = gradient_color(percent)
    [destinations, color]
  end

  def rating
    Carrier::RATING[name]
  end

  def cancellation_rate
    nan_check(((cancellations / flights.to_f) * 100).round(2))
  end

  def avg_departure_delay
    nan_check((total_dep_delay / (flights-cancellations).to_f).round(2))
  end

  def avg_arrival_delay
    nan_check((total_arr_delay / (flights-cancellations).to_f).round(2))
  end

  def std_dev_departure_delay
    nan_check(Math.sqrt((departure_delay_variance / (flights-cancellations).to_f)).round(2))
  end

  def std_dev_arrival_delay
    nan_check(Math.sqrt((arrival_delay_variance / (flights-cancellations).to_f)).round(2))
  end

  def avg_weather_delay
    nan_check((weather_delay / (flights-cancellations).to_f).round(2))
  end

  def avg_carrier_delay
    nan_check((carrier_delay / (flights-cancellations).to_f).round(2))
  end

  def avg_late_aircraft_delay
    nan_check((late_aircraft_delay / (flights-cancellations).to_f).round(2))
  end

  def avg_taxi_in
    nan_check((total_taxi_in / (flights-cancellations).to_f).round(2))
  end

  def avg_taxi_out
    nan_check((total_taxi_out / (flights-cancellations).to_f).round(2))
  end

  def early_arrival_rate
    nan_check(((early_arr_num / flights.to_f) * 100).round(2))
  end

  def late_arrival_rate
    nan_check(((late_arr_num / flights.to_f) * 100).round(2))
  end

  def late_departure_rate
    nan_check(((late_dep_num / flights.to_f) * 100).round(2))
  end

#Scoring

  def flight_score
    if flights >20000
      return 10
    elsif flights > 10000
      return 5
    elsif flights > 5000
      return 3
    else
      return (flights/2000.0).round(1)
    end
  end

  def destination_score
    destinations = destination_hash.keys.length
    if destinations >= 20
      return 10
    elsif destinations >= 15
      return 7
    elsif destinations >= 10
      return 5
    else
      return 0
    end
  end

  def smart_score
    return 0 if flight_score == 0
    score = key_value_score.values[0..-2].reduce(:+) #60
    score += (Carrier::SMART_SCORE_BREAKDOWN[:early_arrival_rate] * diff_percent(Carrier::BENCHMARKS[:early_arrival_rate],early_arrival_rate))#accounting for early_arrival_rate, which needs to be higher not lower - 70
    score += rating #80
    score += flight_score #90
    score += destination_score #100
    score.to_f.nan? ? 0 : score.round(0)
  end

  def smart_z_score
    return 0 if flight_score == 0
    score = key_value_z_score.values.reduce(:+) #70
    score += rating #80
    score += flight_score #90
    score += destination_score #100
    score.to_f.nan? ? 0 : score.round(0)
  end

  def smart_score_color
    score = smart_z_score
    color = gradient_color(score/100.0)
  end


  def key_value_score
    Carrier::BENCHMARKS.keys.inject({}) do |memo, stat|
      memo[stat] = value_score(stat) * Carrier::SMART_SCORE_BREAKDOWN[stat]
      memo
    end
  end

  def value_score(stat)
    value = self.send(stat)
    benchmark = Carrier::BENCHMARKS[stat]
    score = diff_percent(value, benchmark)
  end

  #STANDARD DEVIATION CALCULATION

  def self.key_value_st_dev
    Carrier::BENCHMARKS.keys.inject({}) do |memo, stat|
      memo[stat] = Carrier.st_dev(stat)
      memo
    end
  end

  def self.st_dev(stat)
    mean = Carrier::BENCHMARKS[stat]
    carrs = Carrier.all
    sample = carrs.length
    variance = carrs.map do |carrier|
      value = carrier.send(stat)
      (value - mean)**2
    end
    sum = variance.reduce(:+)
    Math.sqrt(sum/sample).round(4)
  end

  def variable_z_score
    key_value_z_score.values.reduce(:+) #out of 70
  end

  def key_value_z_score
    Carrier::BENCHMARKS.keys.inject({}) do |memo, stat|
      memo[stat] = normalized_z_score(stat) * Carrier::SMART_SCORE_BREAKDOWN[stat]
      memo
    end
  end

  def z_score(stat)
    st_dev = Carrier::ST_DEV[stat]
    mean = Carrier::BENCHMARKS[stat]
    value = self.send(stat)
    #Accounting for the fact that early_arrival_rate is better if it's higher
    if stat != :early_arrival_rate
      (value - mean)/st_dev
    else
      (mean - value)/st_dev
    end
  end

  def normalized_z_score(stat)
    (1 - (z_score(stat) - (-1))/2).round(4)
  end

#Coloring

  def key_value_colors
    Carrier::BENCHMARKS.keys.inject({}) do |memo, stat|
      memo[stat] = value_color(stat)
      memo
    end
  end

  def value_color(stat)
    value = self.send(stat)
    # benchmark = Carrier::BENCHMARKS[stat]
    # percent = diff_percent(value, benchmark)
    percent = normalized_z_score(stat)
    color = gradient_color(percent)
    suffix = (stat.to_s.include?("rate") ? "%" : "mins")
    [value, color, suffix]
  end

#JSON Charts

  def to_json
    {
      carrier_stats: [cancellation_rate, avg_departure_delay, avg_taxi_out, avg_arrival_delay, avg_taxi_in],
      benchmark_stats: benchmark_array[0..-3]
    }
  end

  def self.delay_chart
    carrs = Carrier.all
    {
      carriers: carrs.map(&:name) + ["Benchmark"],
      average_departure_delay: carrs.map(&:avg_departure_delay) + [Carrier::BENCHMARKS[:avg_departure_delay]],
      average_arrival_delay: carrs.map(&:avg_arrival_delay) + [Carrier::BENCHMARKS[:avg_arrival_delay]]
    }
  end

  def self.taxi_chart
    carrs = Carrier.all
    {
      carriers: carrs.map(&:name) + ["Benchmark"],
      average_taxi_in: carrs.map(&:avg_taxi_in) + [Carrier::BENCHMARKS[:avg_taxi_in]],
      average_taxi_out: carrs.map(&:avg_taxi_out) + [Carrier::BENCHMARKS[:avg_taxi_out]]
    }
  end

  def self.rate_chart
    carrs = Carrier.all
    {
      carriers: carrs.map(&:name) + ["Benchmark"],
      cancellation_rate: carrs.map(&:cancellation_rate) + [Carrier::BENCHMARKS[:cancellation_rate]],
      late_departure_rate: carrs.map(&:late_departure_rate) + [Carrier::BENCHMARKS[:late_departure_rate]],
      late_arrival_rate: carrs.map(&:late_arrival_rate) + [Carrier::BENCHMARKS[:late_arrival_rate]],
      early_arrival_rate: carrs.map(&:early_arrival_rate) + [Carrier::BENCHMARKS[:early_arrival_rate]],
    }
  end


  def self.populate_from_flights
    Flight::CARRIERS.each do |carrier|
      flights = Flight.airline(carrier)
      Carrier.create_from_flight_data(flights, carrier)
    end
  end

  private
  def nan_check(value)
    value.nan? ? 0 : value
  end

  def self.create_from_flight_data(flights, carrier)
    name = carrier
    destinations = {}
    flight_num = cancellations = taxi_in = taxi_out = arr_delay = dep_delay = carrier_delay = late_aircraft_delay = weather_delay = 0
    late_dep_num = late_arr_num = early_arr_num = 0
    flights.each do |row|
      flight_num += row.flights.to_i
      cancellations += row.cancelled.to_i
      taxi_in += row.taxi_in.to_i if row.taxi_in != "NA"
      taxi_out += row.taxiout.to_i if row.taxiout != "NA"
      arr_delay += row.arr_time_block.to_i if row.arr_time_block != "NA"
      dep_delay += row.dep_delay.to_i if row.dep_delay != "NA"
      late_arr_num += 1 if row.arr_time_block != "NA" && row.arr_time_block.to_i >= 5
      early_arr_num += 1 if row.arr_time_block != "NA" && row.arr_time_block.to_i < 0
      late_dep_num += 1 if row.dep_delay != "NA" && row.dep_delay.to_i >= 5
      carrier_delay += row.carrier_delay.to_i if row.carrier_delay != "NA"
      weather_delay += row.weather_delay.to_i if row.weather_delay != "NA"
      late_aircraft_delay += row.late_aircraft_delay.to_i if row.late_aircraft_delay != "NA"
      if row.o_market == "New York City, NY (Metropolitan Area)"
        destinations[row.d_market] ||= 0
        destinations[row.d_market] += 1
      end
    end
    dest_string = destinations.map{|d, f| "#{d}--#{f.to_s}"}.join("--")

    #assigning to the carrier
    final = Carrier.new(name: name)
    final.destinations = dest_string
    final.flights = flight_num
    final.cancellations = cancellations
    final.total_taxi_in = taxi_in
    final.total_taxi_out = taxi_out
    final.total_arr_delay = arr_delay
    final.total_dep_delay = dep_delay
    final.carrier_delay = carrier_delay
    final.weather_delay = weather_delay
    final.late_aircraft_delay = late_aircraft_delay
    final.early_arr_num = early_arr_num
    final.late_arr_num = late_arr_num
    final.late_dep_num = late_dep_num

    #calculating standard deviations
    arrival_delay_variance = departure_delay_variance = 0
    arr_delay_mean = final.avg_arrival_delay
    dep_delay_mean = final.avg_departure_delay
    flights.each do |row|
      arrival_delay_variance += (row.arr_time_block.to_i - arr_delay_mean)**2 if row.arr_time_block != "NA"
      departure_delay_variance += (row.dep_delay.to_i - dep_delay_mean) **2 if row.dep_delay != "NA"
    end
    final.arrival_delay_variance = arrival_delay_variance
    final.departure_delay_variance = departure_delay_variance

    #save it
    final.save!
  end

  def benchmark_array
    Carrier::BENCHMARKS.map{|k,v| v}
  end

  def make_channel(a,b, percent)
    (a + ((b - a) * percent).round).to_s
  end

  def gradient_color(percent, color1 = RED, color2 = GREEN)
    color_string = "rgb("
    color_string += make_channel(color1[:r], color2[:r], percent) + ", "
    color_string += make_channel(color1[:g], color2[:g], percent) + ", "
    color_string += make_channel(color1[:b], color2[:b], percent) + ")"
  end

  # CORE CALCULATION FORMULA

  def diff_percent(base, bench)
    value = ((bench - base)/(2.0*((bench).abs + (base).abs))) + 0.5
    dist_from_mean = (0.5 - value).abs
    value = (value >= 0.5 ? [value + dist_from_mean, 1].max : [value - dist_from_mean, 0].min)
  end



end
