require 'test/unit'
require_relative '../../lib/body.rb'
require_relative '../../models/rental.rb'
require_relative '../../models/car.rb'
require_relative '../../models/option.rb'

class BodyTest < Test::Unit::TestCase
  def test_build_body_without_options
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-10", end_date: "2017-12-12", distance: 100)
    car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)

    body = {
      "id" => 1,
      "options" => [],
      "actions" => [
        {
          "who" => "driver",
          "type" => "debit",
          "amount" => 6600
        },
        {
          "who" => "owner",
          "type" => "credit",
          "amount" => 4620
        },
        {
          "who" => "insurance",
          "type" => "credit",
          "amount" => 990
        },
        {
          "who" => "assistance",
          "type" => "credit",
          "amount" => 300
        },
        {
          "who" => "drivy",
          "type" => "credit",
          "amount" => 690
        }
      ]
    }
    assert_equal body, Body.build(rental: rental, car: car), "Should return a valid hash"
  end

  def test_build_body_with_options
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-10", end_date: "2017-12-12", distance: 100)
    car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
    options = [
      Option.new(id: 1, rental_id: 1, type: "baby_seat"),
      Option.new(id: 2, rental_id: 1, type: "gps"),
      Option.new(id: 3, rental_id: 1, type: "additional_insurance")
    ]

    body = {
      "id" => 1,
      "options" => ["baby_seat", "gps", "additional_insurance"],
      "actions" => [
        {
          "who" => "driver",
          "type" => "debit",
          "amount" => 11700
        },
        {
          "who" => "owner",
          "type" => "credit",
          "amount" => 6720
        },
        {
          "who" => "insurance",
          "type" => "credit",
          "amount" => 990
        },
        {
          "who" => "assistance",
          "type" => "credit",
          "amount" => 300
        },
        {
          "who" => "drivy",
          "type" => "credit",
          "amount" => 3690
        }
      ]
    }

    assert_equal body, Body.build(rental: rental, car: car, options: options), "Should return a valid hash"
  end
end