
class Renter
  attr_reader :name,
              :credit_card_number
  
  def initialize(name, ccn)
     @name = name
     @credit_card_number = ccn
  end
end