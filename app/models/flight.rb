class Flight < ActiveRecord::Base
  CARRIERS = [
    "AirTran Airways Corporation",
    "Alaska Airlines Inc.",
    "American Airlines Inc.",
    "Delta Air Lines Inc.",
    "ExpressJet Airlines Inc.",
    "Frontier Airlines Inc.",
    "Hawaiian Airlines Inc.",
    "JetBlue Airways",
    "Mesa Airlines Inc.",
    "SkyWest Airlines Co.",
    "Southwest Airlines Co.",
    "United Air Lines Inc.",
    "US Airways Inc.",
    "Virgin America"
  ]

  DESTINATIONS = [
    "Nantucket, MA",
    "Dallas/Fort Worth, TX",
    "Pittsburgh, PA",
    "Albany, NY",
    "Denver, CO",
    "Atlanta, GA (Metropolitan Area)",
    "Austin, TX",
    "Asheville, NC",
    "Phoenix, AZ",
    "Hartford, CT",
    "Seattle, WA",
    "Bangor, ME",
    "Birmingham, AL",
    "Nashville, TN",
    "Cleveland, OH (Metropolitan Area)",
    "Aguadilla, PR",
    "Boston, MA (Metropolitan Area)",
    "Burlington, VT",
    "Buffalo, NY",
    "Bozeman, MT",
    "Washington, DC (Metropolitan Area)",
    "Chicago, IL",
    "Columbia, SC",
    "Charleston, SC",
    "Charlotte, NC",
    "Columbus, OH",
    "St. Louis, MO",
    "Myrtle Beach, SC",
    "Jacksonville, FL",
    "Dayton, OH",
    "Charleston/Dunbar, WV",
    "Detroit, MI",
    "Des Moines, IA",
    "Houston, TX",
    "Orlando, FL",
    "Minneapolis/St. Paul, MN",
    "New York City, NY (Metropolitan Area)",
    "Fort Myers, FL",
    "Fayetteville, AR",
    "Greenville/Spartanburg, SC",
    "Grand Rapids, MI",
    "Greensboro/High Point, NC",
    "Honolulu, HI",
    "Las Vegas, NV",
    "Indianapolis, IN",
    "San Francisco, CA (Metropolitan Area)",
    "Miami, FL (Metropolitan Area)",
    "Louisville, KY",
    "Cincinnati, OH",
    "Sacramento, CA",
    "San Antonio, TX",
    "Memphis, TN",
    "Los Angeles, CA (Metropolitan Area)",
    "Tampa, FL (Metropolitan Area)",
    "Kansas City, MO",
    "Omaha, NE",
    "Milwaukee, WI",
    "Madison, WI",
    "New Orleans, LA",
    "Martha's Vineyard, MA",
    "San Diego, CA",
    "Norfolk, VA (Metropolitan Area)",
    "Portland, OR",
    "Oklahoma City, OK",
    "West Palm Beach/Palm Beach, FL",
    "Philadelphia, PA",
    "Ponce, PR",
    "Portland, ME",
    "Raleigh/Durham, NC",
    "Richmond, VA",
    "Rochester, NY",
    "Salt Lake City, UT",
    "Tulsa, OK",
    "Savannah, GA",
    "South Bend, IN",
    "San Juan, PR",
    "Charlotte Amalie, VI",
    "Sarasota/Bradenton, FL",
    "Syracuse, NY",
    "Knoxville, TN"
  ]

  def self.airline(name)
    self.where(carrier: name)
  end

  def self.destinations
    d_hash = {}
    Flight.all.each do |row|
      d_hash[row.d_market] = true if !d_hash[row.d_market]
    end
    d_hash.keys
  end
end
