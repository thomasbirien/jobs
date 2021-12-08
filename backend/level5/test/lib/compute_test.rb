require 'test/unit'
require_relative '../../lib/compute.rb'
require_relative '../../models/rental.rb'
require_relative '../../models/car.rb'
require_relative '../../models/option.rb'

class ComputeTest < Test::Unit::TestCase
  def test_compute_price
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-8", end_date: "2017-12-8", distance: 100)
    car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
    Compute.new(rental: rental, car: car)
    assert_equal 3000, Compute.compute_price, "Should return 5000"
  end

  def test_compute_price_decrease
    # test compute with 10% discount
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-8", end_date: "2017-12-9", distance: 300)
    car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
    Compute.new(rental: rental, car: car)
    assert_equal 6800, Compute.compute_price, "Should return 6800, because price_per_day decrease 10%"
    
    # test compute with 10% and 30% discount
    rental = Rental.new(id: 2, car_id: 2, start_date: "2017-12-8", end_date: "2017-12-10", distance:  500)
    car = Car.new(id: 2, price_per_day: 2000, price_per_km: 10)
    Compute.new(rental: rental, car: car)
    assert_equal 10600, Compute.compute_price, "Should return 10600, because price_per_day decrease 10% and 30%"

    # test compute with 10%, 30% and 50% discount
    rental = Rental.new(id: 3, car_id: 3, start_date: "2017-12-1", end_date: "2017-12-12", distance:  1000)
    car = Car.new(id: 3, price_per_day: 2000, price_per_km: 10)
    Compute.new(rental: rental, car: car)
    assert_equal 27800, Compute.compute_price, "Should return 27800, because price_per_day decrease 10%, 30% and 50%"
  end

  def test_compute_fees
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-8", end_date: "2017-12-9", distance: 300)
    car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
    Compute.new(rental: rental, car: car)
    price = Compute.compute_price
    total_fee = Compute.total_fee(price)
    insurance_fee = Compute.insurance_fee(total_fee)
    assistance_fee = Compute.assistance_fee(rental.days)

    assert_equal 2040, total_fee, "Should return 30% of price"

    assert_equal 1020, Compute.insurance_fee(total_fee), "Should return 2380, we take the half of 30% fee"

    assert_equal 200, Compute.assistance_fee(rental.days), "Should return 2, because all days start is due"

    assert_equal 820, Compute.drivy_fee(
      fee: total_fee,
      insurance_fee: insurance_fee,
      assistance_fee: assistance_fee
    ), "Should return 820, is the rest of fee for drivy"
  end

  def test_compute_drivy_fee_with_options
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-8", end_date: "2017-12-9", distance: 300)
    car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
    options = [
      Option.new(id: 1, rental_id: 1, type: "baby_seat"),
      Option.new(id: 2, rental_id: 1, type: "gps"),
      Option.new(id: 3, rental_id: 1, type: "additional_insurance")
    ]
    Compute.new(rental: rental, car: car, options: options)
    price = Compute.compute_price
    total_fee = Compute.total_fee(price)
    insurance_fee = Compute.insurance_fee(total_fee)
    assistance_fee = Compute.assistance_fee(rental.days)

    assert_equal 2820, Compute.drivy_fee(
      fee: total_fee,
      insurance_fee: insurance_fee,
      assistance_fee: assistance_fee
    ), "Should return 8282020, is the rest of fee for drivy with option"
  end

  def test_compute_price_for_owner_with_options
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-8", end_date: "2017-12-9", distance: 300)
    car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
    options = [
      Option.new(id: 1, rental_id: 1, type: "baby_seat"),
      Option.new(id: 2, rental_id: 1, type: "gps"),
      Option.new(id: 3, rental_id: 1, type: "additional_insurance")
    ]
    Compute.new(rental: rental, car: car, options: options)
    price = Compute.compute_price
    assert_equal 6160, Compute.compute_price_owner(price), "Should return 6160, because price_per_day decrease 10% with options "
  end


  def test_compute_price_for_owner_without_options
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-8", end_date: "2017-12-9", distance: 300)
    car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
    Compute.new(rental: rental, car: car)
    price = Compute.compute_price
    assert_equal 4760, Compute.compute_price_owner(price), "Should return 4760, because price_per_day decrease 10% without options"
  end

  def test_compute_price_driver_with_options
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-8", end_date: "2017-12-9", distance: 300)
    car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
    options = [
      Option.new(id: 1, rental_id: 1, type: "baby_seat"),
      Option.new(id: 2, rental_id: 1, type: "gps"),
      Option.new(id: 3, rental_id: 1, type: "additional_insurance")
    ]

    Compute.new(rental: rental, car: car, options: options)

    assert_equal 10200, Compute.compute_price_driver, "Should return 10200, because price_per_day decrease 10% with options"
  end

  def test_compute_price_driver_without_options
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-8", end_date: "2017-12-9", distance: 300)
    car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
    Compute.new(rental: rental, car: car)

    assert_equal 6800, Compute.compute_price_driver, "Should return 10200, because price_per_day decrease 10% without options"
  end
end