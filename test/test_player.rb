require 'minitest'
require 'minitest/autorun'

require 'player'
require 'card'
require 'deck'

class TestPlayer < Minitest::Test

  def setup
    @p = Player.new('first')
    @h11 = Hand.new(Card.new(5, :clubs), Card.new(6, :clubs))
    @h16 = Hand.new(Card.new(8, :clubs), Card.new(8, :spades))
  end

  def test_init
    assert @p.hands.empty?
    assert_equal 100, @p.bankroll
    assert_equal 0, @p.total_bet
  end

  def test_deal
    assert_raises(RuntimeError) {
      @p.deal @h11
    }
    @p.initial_bet 1
    assert_equal 99, @p.bankroll
    assert_equal 1, @p.total_bet
    @p.deal @h11
    assert_equal 1, @p.hands.size
    assert_equal @h11, @p.active_hand
  end

  def test_stand
    @p.initial_bet 1
    @p.deal @h11
    # no more hands, should return false
    assert !@p.stand!
  end

  def test_hit
    @p.initial_bet 1
    @p.deal @h11
    # hand did not bust, should return true
    assert @p.hit!(Card.new(3, :clubs))
    # bust, returns false
    assert !@p.hit!(Card.new(:K, :clubs))
  end

  def test_double
    @p.initial_bet 1
    @p.deal @h11
    assert !@p.double!(Card.new(:K, :clubs))
    assert_equal 2, @p.total_bet
    assert_equal 98, @p.bankroll
  end

  def test_split_error
    @p.initial_bet 1
    @p.deal @h11
    assert_raises(RuntimeError) {
      @p.split! Card.new(:K, :clubs), Card.new(:Q, :clubs)
    }
  end

  def test_split_stand_hit
    @p.initial_bet 1
    @p.deal @h16
    assert @p.split!(Card.new(:K, :clubs), Card.new(9, :clubs))
    assert_equal 2, @p.hands.size
    assert_equal @p.hands[0], @p.active_hand
    assert_equal 18, @p.active_hand.total
    assert @p.stand!
    assert_equal 2, @p.hands.size
    assert_equal @p.hands[1], @p.active_hand
    assert_equal 17, @p.active_hand.total
    assert @p.hit!(Card.new(2, :clubs))
    assert_equal 19, @p.active_hand.total
    assert !@p.stand!
  end

  def test_split_stand_double
    @p.initial_bet 1
    @p.deal @h16
    assert @p.split!(Card.new(:K, :clubs), Card.new(3, :clubs))
    assert_equal 2, @p.hands.size
    assert_equal @p.hands[0], @p.active_hand
    assert_equal 18, @p.active_hand.total
    assert @p.stand!
    assert_equal 2, @p.hands.size
    assert_equal @p.hands[1], @p.active_hand
    assert_equal 11, @p.active_hand.total
    assert !@p.double!(Card.new(2, :clubs))
  end

  def test_payout_poststate
    @p.initial_bet 1
    @p.deal @h16
    assert_equal 2, @p.payout(@h11)
    assert_equal 101, @p.bankroll
    assert_equal 0, @p.total_bet
    assert @p.hands.empty?
  end

  def test_payout_split_winone
    @p.initial_bet 1
    @p.deal @h16
    assert @p.split!(Card.new(:K, :clubs), Card.new(2, :clubs))
    assert_equal 2, @p.payout(@h11)
  end

  def test_payout_split_wintwo
    @p.initial_bet 1
    @p.deal @h16
    assert @p.split!(Card.new(:K, :clubs), Card.new(:Q, :clubs))
    assert_equal 4, @p.payout(@h11)
  end

  def test_payout_split_zero
    @p.initial_bet 1
    @p.deal @h16
    assert @p.split!(Card.new(2, :clubs), Card.new(3, :clubs))
    assert_equal 0, @p.payout(@h16)
  end

  class ConstantAction
    def initialize(action)
      @action = action
    end
    def prompt_action(hand, inc, bank)
      @action
    end
  end

  class MockDeck
    def initialize(*cards)
      @cards = cards
    end
    def deal!
      @cards.shift
    end
  end

  def test_take_action_stand
    @p = Player.new 'first', ConstantAction.new('s')
    @p.initial_bet 1
    @p.deal @h16
    # stand should always return false
    assert !@p.take_action(nil)
  end

  def test_take_action_hit
    @p = Player.new 'first', ConstantAction.new('h')
    @p.initial_bet 1
    @p.deal @h16
    deck = MockDeck.new Card.new(2, :clubs), Card.new(5, :clubs)
    # hit, 18 no bust
    assert @p.take_action(deck)
    # hit, 23 bust
    assert !@p.take_action(deck)
  end

  def test_take_action_double
    @p = Player.new 'first', ConstantAction.new('d')
    @p.initial_bet 1
    @p.deal @h16
    deck = MockDeck.new Card.new(3, :clubs)
    # must move to next hand when doubling
    assert !@p.take_action(deck)
  end

  def test_take_action_split
    @p = Player.new 'first', ConstantAction.new('p')
    @p.initial_bet 1
    @p.deal @h16
    deck = MockDeck.new Card.new(3, :clubs), Card.new(2, :clubs)
    # more hands still exist
    assert @p.take_action(deck)
  end

  def test_take_action_split_doubleblackjack
    @p = Player.new 'first', ConstantAction.new('p')
    @p.initial_bet 1
    @p.deal Hand.new(Card.new(:A, :clubs), Card.new(:A, :clubs))
    deck = MockDeck.new Card.new(10, :clubs), Card.new(10, :spades)
    # more hands still exist
    assert @p.take_action(deck)
  end
end
