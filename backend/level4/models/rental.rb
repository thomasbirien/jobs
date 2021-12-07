class Rental
  require 'Date'
  attr_accessor :id, :car_id, :start_date, :end_date, :distance

  def initialize(id, car_id, start_date, end_date, distance)
    @id = id
    @car_id = car_id
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end


  def days
    start_date = Date.strptime(self.start_date, '%Y-%m-%d')
    end_date = Date.strptime(self.end_date, '%Y-%m-%d')
    days = (end_date - start_date).to_i
  end
end