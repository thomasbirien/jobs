class Compute
  require_relative 'models/car.rb'
  require_relative 'models/rental.rb'

  def self.give_hash(rental, car)
    hash_to_return = {"id" => rental.id, "price" => Compute.compute_price(rental, car)}
  end

  def self.compute_price(rental, car)
    price_distance = rental.distance * car.price_per_km
    price_days = car.price_per_day + (rental.days * car.price_per_day)
    total_price = price_distance + price_days
  end
end