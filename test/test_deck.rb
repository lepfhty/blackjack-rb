require 'minitest'
require 'minitest/autorun'

require 'deck'

class TestDeck < Minitest::Test
  def setup
    @deck = Deck.new
    @deck6 = Deck.new(6)
  end

  def test_deck
    assert_equal @deck.size, 52
    assert_equal @deck6.size, 52 * 6
    53.times do
      puts @deck.deal!
    end
  end
end
