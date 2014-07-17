require 'minitest'
require 'minitest/autorun'

require 'deck'

class TestDeck < Minitest::Test
  def setup
    @deck = Deck.new
    @deck6 = Deck.new(6)
  end

  def test_deck
    assert_equal 1.0, @deck.size
    assert_equal 1.0, @deck6.size
  end

  def test_reshuffle
    a = @deck.deal!
    b = @deck.deal!
    assert @deck.size < 1
    @deck.reshuffle!
    assert_equal 1.0, @deck.size
    c = @deck.deal!
    d = @deck.deal!
    assert @deck.size < 1
    assert "#{a} #{b}" != "#{c} #{d}"
  end
end
