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

  def find_total_charge(boat)
    hours_rented = boat.hours_rented
    pph = boat.price_per_hour
    max = @max_rental_time
    actual = [hours_rented, max].min
    charge = actual * pph
  end


  def charge(boat)
    holder = {}
    holder[:card_nmuber] = @rental_log[boat].credit_card_number
    holder[:amount] = find_total_charge(boat)
    holder
  end


end

