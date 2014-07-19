require 'test_helper'

require 'deck'

class TestDeck < Minitest::Test
  def setup
    @deck = Deck.new
    @deck6 = Deck.new(6)
  end

  def test_deck
    assert_equal 1.0, @deck.fraction
    assert_equal 52, @deck.size
    assert_equal 1.0, @deck6.fraction
    assert_equal 52*6, @deck6.size
  end

  def test_reshuffle
    a = @deck.deal!
    b = @deck.deal!
    assert_equal 50, @deck.size
    assert @deck.fraction < 1
    @deck.reshuffle!
    assert_equal 1.0, @deck.fraction
    c = @deck.deal!
    d = @deck.deal!
    assert_equal 50, @deck.size
    assert @deck.fraction < 1
    assert "#{a} #{b}" != "#{c} #{d}"
  end
end
