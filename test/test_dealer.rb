require 'test_helper'

require 'dealer'

require 'mocks'

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

  def test_take_action
    deck = MockDeck.new Card.new(10, :clubs), Card.new(:K, :clubs)
    @dealer.deal @hand
    assert_equal 5, @dealer.active_hand.total
    assert @dealer.take_action(deck, false)
    assert_equal 15, @dealer.active_hand.total
    assert !@dealer.take_action(deck, false)
    assert_equal 25, @dealer.active_hand.total
  end

  def test_take_action_stand
    deck = MockDeck.new Card.new(10, :clubs), Card.new(4, :clubs)
    @dealer.deal @hand
    assert_equal 5, @dealer.active_hand.total
    assert @dealer.take_action(deck, false)
    assert_equal 15, @dealer.active_hand.total
    assert @dealer.take_action(deck, false)
    assert_equal 19, @dealer.active_hand.total
    assert !@dealer.take_action(deck, false)
    assert_equal 19, @dealer.active_hand.total
  end

  def test_take_action_soft17
    deck = MockDeck.new(Card.new(:A, :clubs), Card.new(:A, :spades),
      Card.new(5, :clubs), Card.new(:K, :clubs))
    @dealer.deal @hand
    assert_equal 5, @dealer.active_hand.total
    assert @dealer.take_action(deck, false)
    assert_equal 16, @dealer.active_hand.total
    assert @dealer.take_action(deck, false)
    assert_equal 17, @dealer.active_hand.total
    assert @dealer.take_action(deck, false)
    assert_equal 12, @dealer.active_hand.total
    assert !@dealer.take_action(deck, false)
    assert_equal 22, @dealer.active_hand.total
  end
end
