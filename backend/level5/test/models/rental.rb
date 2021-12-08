require 'test/unit'
require_relative '../../models/rental.rb'

class RentalTest < Test::Unit::TestCase
  def test_days
    rental = Rental.new(id: 1, car_id: 1, start_date: "2017-12-10", end_date: "2017-12-12", distance: 100)
    assert_equal 2, rental.days, "Should return 5000"
  end
end