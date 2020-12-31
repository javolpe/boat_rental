require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'
require './lib/renter'
require 'pry'

class BoatTest < Minitest::Test 
  def test_boat_exisits 
    kayak = Boat.new(:kayak, 20) 

    assert_instance_of Boat, kayak
  end

  def test_boat_has_readable_attributes
    kayak = Boat.new(:kayak, 20) 

    assert_equal 20, kayak.price_per_hour
    assert_equal :kayak, kayak.type
    assert_equal 0, kayak.hours_rented
  end

  def test_boat_hours_rented_goes_up_by_one
    kayak = Boat.new(:kayak, 20) 
    kayak.add_hour
    kayak.add_hour
    kayak.add_hour

    assert_equal 3, kayak.hours_rented
  end


end