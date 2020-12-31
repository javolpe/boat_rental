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

  def test_find_total_charge
    dock = Dock.new("The Rowing Dock", 3) 
    kayak_1 = Boat.new(:kayak, 20)
    patrick = Renter.new("Patrick Star", "4242424242424242") 
    dock.rent(kayak_1, patrick)
    kayak_1.add_hour
    kayak_1.add_hour
    expected = dock.find_total_charge(kayak_1)

    assert_equal 40, expected
  end

  def test_dock_charge
    dock = Dock.new("The Rowing Dock", 3) 
    kayak_1 = Boat.new(:kayak, 20)
    patrick = Renter.new("Patrick Star", "4242424242424242") 
    dock.rent(kayak_1, patrick)
    kayak_1.add_hour
    kayak_1.add_hour
    expected = dock.charge(kayak_1)

    assert_equal 2, kayak_1.hours_rented
    assert_equal 2, expected.count
    assert_equal "4242424242424242", expected[:card_nmuber]
    assert_equal 40, expected[:amount]
  end

  def test_dock_charge_wont_go_above_max
    dock = Dock.new("The Rowing Dock", 3) 
    sup_1 = Boat.new(:standup_paddle_board, 15)
    eugene = Renter.new("Eugene Crabs", "1313131313131313") 
    dock.rent(sup_1, eugene)
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    expected = dock.charge(sup_1)

    assert_equal 5, sup_1.hours_rented
    assert_equal 2, expected.count
    assert_equal "1313131313131313", expected[:card_nmuber]
    assert_equal 45, expected[:amount]
  end

  def test_log_hour
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    canoe = Boat.new(:canoe, 25) 

    assert_equal 0, kayak_1.hours_rented
    assert_equal 0, kayak_2.hours_rented
    assert_equal 2, dock.rental_log.count

    dock.log_hour

    assert_equal 1, kayak_1.hours_rented
    assert_equal 1, kayak_2.hours_rented
    assert_equal 2, dock.rental_log.count

    dock.rent(canoe, patrick)
    dock.log_hour

    assert_equal 2, kayak_1.hours_rented
    assert_equal 2, kayak_2.hours_rented
    assert_equal 1, canoe.hours_rented
    assert_equal 0, dock.revenue
  end

  def test_return_resets_things_and_adds_revenue
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    canoe = Boat.new(:canoe, 25) 
    sup_1 = Boat.new(:standup_paddle_board, 15) 
    sup_2 = Boat.new(:standup_paddle_board, 15) 

    assert_equal 0, kayak_1.hours_rented
    assert_equal 0, kayak_2.hours_rented
    assert_equal 2, dock.rental_log.count

    dock.log_hour

    assert_equal 1, kayak_1.hours_rented
    assert_equal 1, kayak_2.hours_rented
    assert_equal 2, dock.rental_log.count

    dock.rent(canoe, patrick)
    dock.log_hour

    assert_equal 2, kayak_1.hours_rented
    assert_equal 2, kayak_2.hours_rented
    assert_equal 1, canoe.hours_rented
    assert_equal 0, dock.revenue

    dock.return(kayak_1)
    dock.return(kayak_2)
    dock.return(canoe)

    assert_equal 105, dock.revenue
    
    dock.rent(sup_1, eugene)
    dock.rent(sup_2, eugene)
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.return(sup_1)
    dock.return(sup_2)
    
    assert_equal 195, dock.revenue
    assert_equal 0, sup_1.hours_rented
  end


end