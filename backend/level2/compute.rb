module Compute
  require_relative 'models/car.rb'
  require_relative 'models/rental.rb'

  def self.give_hash(rental:, car:)
    hash_to_return = {"id" => rental.id, "price" => compute_price(rental: rental, car: car)}
  end

  module_function def compute_price(rental:, car:)
    return compute_price_without_discount(rental: rental, car: car) unless rental.days >= 1
    compute_price_with_discount(rental: rental, car: car)
  end

  module_function def compute_price_without_discount(rental:, car:)
    price_distance = rental.distance * car.price_per_km
    total_price = price_distance + car.price_per_day
  end

  module_function def compute_price_with_discount(rental:, car:)
    price_distance = rental.distance * car.price_per_km
    price_days = decrease_price(days: rental.days, price_per_day: car.price_per_day).to_i
    total_price = price_distance + price_days
  end

  module_function def decrease_price(days:, price_per_day:)
    return total_price_decrease_for_ten_days_minimal(days: days, price_per_day: price_per_day) if days >= 10
    return total_price_decrease_for_four_days_minimal(days: days, price_per_day: price_per_day) if days >= 4
    return total_price_decrease_for_one_days_minimal(days: days, price_per_day: price_per_day) if days >= 1
  end

  module_function def discount(price_per_day)
    {
      discount_10: price_per_day - (price_per_day * 0.10),
      discount_30: price_per_day - (price_per_day * 0.30),
      discount_50: price_per_day - (price_per_day * 0.50)
    }
  end

  module_function def total_price_decrease_for_ten_days_minimal(days:, price_per_day:)
    remaining_days = days - 9
    price_decrease = price_per_day +
      (discount(price_per_day)[:discount_10] * 3) +
      (discount(price_per_day)[:discount_30] * 6) +
      (discount(price_per_day)[:discount_50] * remaining_days)
  end

  module_function def total_price_decrease_for_four_days_minimal(days:, price_per_day:)
    remaining_days = days - 3
    price_decrease = price_per_day +
      (discount(price_per_day)[:discount_10] * 3) +
      (discount(price_per_day)[:discount_30] * remaining_days)
  end

  module_function def total_price_decrease_for_one_days_minimal(days:, price_per_day:)
    price_decrease = price_per_day +
      (discount(price_per_day)[:discount_10] * days)
  end
end