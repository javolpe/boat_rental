class Dock
  attr_reader :name,
              :max_rental_time,
              :rental_log
  
  def initialize(name, mrt)
     @name            = name
     @max_rental_time = mrt
     @rental_log = {}
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end
end