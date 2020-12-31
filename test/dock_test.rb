require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'
require './lib/renter'
require './lib/dock'
require 'pry'

class DockTest < Minitest::Test 
  def test_dock_exisits 
    dock = Dock.new("The Rowing Dock", 3) 

    assert_instance_of Dock, dock
  end

  def test_dock_has_readable_attributes
    dock = Dock.new("The Rowing Dock", 3) 

    assert_equal "The Rowing Dock", dock.name
    assert_equal 3, dock.max_rental_time
  end

  def test_rent_adds_one_boat_to_log 
    dock = Dock.new("The Rowing Dock", 3) 
    kayak_1 = Boat.new(:kayak, 20)
    patrick = Renter.new("Patrick Star", "4242424242424242") 
    dock.rent(kayak_1, patrick)

    assert_equal 1, dock.rental_log.count
    assert_equal patrick, dock.rental_log[kayak_1]
    assert_equal kayak_1, dock.rental_log.keys[0]
  end

  def test_rental_log_works
    dock = Dock.new("The Rowing Dock", 3) 
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20) 
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242") 
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick) 
    dock.rent(sup_1, eugene) 

    assert_equal 3, dock.rental_log.count
    assert_equal patrick, dock.rental_log[kayak_1]
    assert_equal patrick, dock.rental_log[kayak_2]
    assert_equal eugene, dock.rental_log[sup_1]
    assert_equal [kayak_1, kayak_2, sup_1], dock.rental_log.keys
  end
end