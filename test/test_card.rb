require 'minitest'
require 'minitest/autorun'

require 'card'

class TestCard < Minitest::Test
  def setup
    @cards = Card::VALUES.map { |v| Card.new v, :spades }
  end

  def test_compare
    # assumes that Card::VALUES is in ascending order
    (0..11).each do |i|
      assert(@cards[i] < @cards[i+1])
    end
  end

  def test_num_value
    assert_equal @cards[9].value, :J
    assert_equal @cards[9].num_value, 10
    assert_equal @cards[10].value, :Q
    assert_equal @cards[10].num_value, 10
    assert_equal @cards[11].value, :K
    assert_equal @cards[11].num_value, 10
    assert_equal @cards[12].value, :A
    assert_equal @cards[12].num_value, 11
  end

  def test_to_s
    assert_equal Card.new(:A, :spades).to_s, " A\u2664"
    assert_equal Card.new(:A, :hearts).to_s, " A\u2665"
    assert_equal Card.new(:A, :diamonds).to_s, " A\u2666"
    assert_equal Card.new(:A, :clubs).to_s, " A\u2667"
  end
end
