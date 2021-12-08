module Body
  def self.build(rental:, car:, options: [])
    @rental = rental
    @car = car
    @options = options
    Compute.new(rental: @rental, car: @car, options: @options)

    body_to_build = {
      "id" => @rental.id,
      "options" => options_type,
      "actions" => body_actions
    }
  end

  module_function def options_type
    return [] unless @options.any?
    @options.map {|option| option.type}
  end

  module_function def body_actions
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
      "amount" => Compute.compute_price_driver
    }
  end
  module_function def body_owner
    {
      "who" => "owner",
      "type" => "credit",
      "amount" => Compute.compute_price_owner(Compute.compute_price)
    }
  end
  module_function def body_insurance
    {
      "who" => "insurance",
      "type" => "credit",
      "amount" => Compute.insurance_fee(
        Compute.total_fee(Compute.compute_price)
      )
    }
  end
  module_function def body_assistance
    {
      "who" => "assistance",
      "type" => "credit",
      "amount" => Compute.assistance_fee(@rental.days)
    }
  end
  module_function def body_drivy
    {
      "who" => "drivy",
      "type" => "credit",
      "amount" => Compute.drivy_fee(
        fee: Compute.total_fee(Compute.compute_price),
        insurance_fee: Compute.insurance_fee(
          Compute.total_fee(Compute.compute_price)
        ),
        assistance_fee: Compute.assistance_fee(@rental.days)
      )
    }
  end
end