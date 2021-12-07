require 'test/unit'
require_relative '../compute.rb'
require_relative '../models/rental.rb'
require_relative '../models/car.rb'

class ComputeTest < Test::Unit::TestCase
  def test_compute_price
    rental = Rental.new(id = 1, car_id = 1, start_date = "2017-12-8", end_date = "2017-12-8", distance = 100)
    car = Car.new(id = 1, price_per_day = 2000, price_per_km = 10)
    assert_equal 3000, Compute.compute_price(rental: rental, car: car), "Should return 5000"
  end

  def test_compute_price_decrease
    # test compute with 10% discount
    rental = Rental.new(id = 1, car_id = 1, start_date = "2017-12-8", end_date = "2017-12-9", distance = 300)
    car = Car.new(id = 1, price_per_day = 2000, price_per_km = 10)
    assert_equal 6800, Compute.compute_price(rental: rental, car: car), "Should return 6800, because price_per_day decrease 10%"
    
    # test compute with 10% and 30% discount
    rental = Rental.new(id = 2, car_id = 2, start_date = "2017-12-8", end_date = "2017-12-10", distance = 500)
    car = Car.new(id = 2, price_per_day = 2000, price_per_km = 10)
    assert_equal 10600, Compute.compute_price(rental: rental, car: car), "Should return 10600, because price_per_day decrease 10% and 30%"

    # test compute with 10%, 30% and 50% discount
    rental = Rental.new(id = 3, car_id = 3, start_date = "2017-12-1", end_date = "2017-12-12", distance = 1000)
    car = Car.new(id = 3, price_per_day = 2000, price_per_km = 10)
    assert_equal 27800, Compute.compute_price(rental: rental, car: car), "Should return 27800, because price_per_day decrease 10%, 30% and 50%"
  end
end