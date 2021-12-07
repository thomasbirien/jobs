require 'test/unit'
require_relative '../compute.rb'
require_relative '../models/rental.rb'
require_relative '../models/car.rb'

class ComputeTest < Test::Unit::TestCase
  def test_compute_price
    rental = Rental.new(id = 1, car_id = 1, start_date = "2017-12-8", end_date = "2017-12-10", distance = 100)
    car = Car.new(id = 1, price_per_day = 2000, price_per_km = 10)
    assert_equal 7000, Compute.compute_price(rental, car), "Should return 7000"
  end
end
