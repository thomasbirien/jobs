module Compute
  require_relative 'models/car.rb'
  require_relative 'models/rental.rb'

  def self.new(rental:, car:)
    @rental = rental
    @car = car
  end

  def self.give_hash
    hash_to_return = {
      "id" => @rental.id,
      "actions" => body_actions(total_fee(compute_price))
    }
  end

  module_function def body_actions(total_fee)
    [
      body_driver,
      body_owner,
      body_insurance,
      body_assistance,
      body_drivy
    ]
  end

  module_function def body_driver
    {
      "who" => "driver",
      "type" => "debit",
      "amount" => compute_price
    }
  end
  module_function def body_owner
    {
      "who" => "owner",
      "type" => "credit",
      "amount" => compute_price_owner(compute_price)
    }
  end
  module_function def body_insurance
    {
      "who" => "insurance",
      "type" => "credit",
      "amount" => insurance_fee(total_fee(compute_price))
    }
  end
  module_function def body_assistance
    {
      "who" => "assistance",
      "type" => "credit",
      "amount" => assistance_fee(@rental.days)
    }
  end
  module_function def body_drivy
    {
      "who" => "drivy",
      "type" => "credit",
      "amount" => drivy_fee(
        fee: total_fee(compute_price),
        insurance_fee: insurance_fee(total_fee(compute_price)),
        assistance_fee: assistance_fee(@rental.days)
      )
    }
  end

  module_function def compute_price
    return compute_price_without_discount unless @rental.days >= 1
    compute_price_with_discount
  end

  module_function def compute_price_without_discount
    price_distance = @rental.distance * @car.price_per_km
    total_price = price_distance + @car.price_per_day
  end

  module_function def compute_price_with_discount
    price_distance = @rental.distance * @car.price_per_km
    price_days = decrease_price(days: @rental.days, price_per_day: @car.price_per_day).to_i
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

  module_function def total_fee(price)
    (price * 0.30).to_i
  end

  module_function def insurance_fee(fee)
    (fee / 2).to_i
  end

  module_function def assistance_fee(days)
    ((days + 1) * 100).to_i
  end

  module_function def drivy_fee(fee:, insurance_fee:, assistance_fee:)
    (fee - insurance_fee - assistance_fee).to_i
  end

  module_function def compute_price_owner(price)
    (price - (price * 0.30)).to_i
  end
end