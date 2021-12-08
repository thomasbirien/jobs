module Compute
  def self.new(rental:, car:, options: [])
    @rental = rental
    @car = car
    @options = options
  end

  def self.compute_price
    return compute_price_without_discount unless @rental.days >= 1
    compute_price_with_discount
  end

  module_function def compute_price_without_discount
    price_distance = @rental.distance * @car.price_per_km
    total_price = price_distance + @car.price_per_day
  end

  module_function def compute_price_with_discount
    price_distance = @rental.distance * @car.price_per_km
    total_price = price_distance + decrease_price
  end

  module_function def total_price_options
    return 0 unless @options.any?
    @options.map {|option| option.price * (@rental.days + 1)}.sum
  end

  module_function def total_price_options_for_owner
    return 0 unless @options.any?
    return 0 if @options.size == 1 || @options.first.type == "additional_insurance"
    @options.map do |option|
      next if option.type == "additional_insurance"
      option.price * (@rental.days + 1)
    end.compact.sum
  end

  module_function def total_price_options_for_drivy
    return 0 unless @options.any?
    return 0 unless @options.map {|opt| opt.type}.include?("additional_insurance")
    @options.select{|opt| opt.type == "additional_insurance"}.first.price * (@rental.days + 1)
  end

  module_function def decrease_price
    day_passed = 0
    total = @car.price_per_day

    (0..@rental.days).each do |day|
      if day_passed >= 10
        total += (discount[:discount_50])
      elsif day_passed >= 4
        total += (discount[:discount_30])
      elsif day_passed >= 1
        total += (discount[:discount_10])
      end
      day_passed += 1
    end

    total.to_i
  end

  module_function def discount
    {
      discount_10: @car.price_per_day - (@car.price_per_day * 0.10),
      discount_30: @car.price_per_day - (@car.price_per_day * 0.30),
      discount_50: @car.price_per_day - (@car.price_per_day * 0.50)
    }
  end

  def self.total_fee(price)
    (price * 0.30).to_i
  end

  def self.insurance_fee(fee)
    (fee / 2).to_i
  end

  def self.assistance_fee(days)
    ((days + 1) * 100).to_i
  end

  def self.drivy_fee(fee:, insurance_fee:, assistance_fee:)
    (fee - insurance_fee - assistance_fee).to_i + total_price_options_for_drivy
  end

  def self.compute_price_owner(price)
    (price - (price * 0.30)).to_i + total_price_options_for_owner
  end

  def self.compute_price_driver
    Compute.compute_price + total_price_options
  end
end