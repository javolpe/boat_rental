require './lib/renter'

class Boat
  attr_accessor :hours_rented

  attr_reader :type,
              :price_per_hour

  def initialize(type, price)
     @type = type
     @price_per_hour = price
     @hours_rented = 0
  end

  def add_hour
    @hours_rented +=1
  end

end