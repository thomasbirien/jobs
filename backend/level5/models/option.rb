class Option
  attr_accessor :id, :rental_id, :type
  def initialize(id:, rental_id:, type:)
    @id = id
    @rental_id = rental_id
    @type = type
  end

  def price
    case type
    when "gps"
      500
    when "baby_seat"
      200
    when "additional_insurance"
      1000
    end
  end
end