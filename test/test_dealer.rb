require 'test_helper'

require 'dealer'

class TestDealer < Minitest::Test
  def setup
    @dealer = Dealer.new
    @c1 = Card.new(2, :clubs)
    @hand = Hand.new @c1, Card.new(3, :clubs)
  end

  def test_name
    assert_equal 'Dealer', @dealer.name
  end

  def test_deal_active_hand
    h = @dealer.deal @hand
    assert_equal @hand, h
    assert_equal @hand, @dealer.active_hand
  end

  def test_to_s
    str = @dealer.to_s
    assert str.include?(@dealer.name)
    assert str.include?(@dealer.active_hand.to_s)
  end

  def test_faceup_card
    @dealer.deal @hand
    assert_equal @c1, @dealer.faceup_card
  end
end
