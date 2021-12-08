require 'json'

require_relative 'models/car.rb'
require_relative 'models/rental.rb'
require_relative 'models/option.rb'
require_relative 'lib/body.rb'
require_relative 'lib/compute.rb'

input = JSON.parse(File.open("data/input.json").read)

rentals = []
input["rentals"].each do |rental_data|
  rental = Rental.new(
    id: rental_data["id"],
    car_id: rental_data["car_id"],
    start_date: rental_data["start_date"],
    end_date: rental_data["end_date"],
    distance: rental_data["distance"]
  )

  car_data = input["cars"].select{|car_data| rental.car_id == car_data["id"]}.first
  car = Car.new(
    id: car_data["id"],
    price_per_day: car_data["price_per_day"],
    price_per_km: car_data["price_per_km"]
  )
  option_data = input["options"].select{|opt_data| opt_data["rental_id"] == rental.id}
  options = []
  if option_data.any?
    option_data.each do |opt_data|
      options << Option.new(id: opt_data["id"], rental_id: opt_data["rental_id"], type: opt_data["type"])
    end
  end

  rentals << Body.build(rental: rental, car: car, options: options)
end

File.open("data/output.json","w") do |f|
  f.write({"rentals" => rentals}.to_json)
end