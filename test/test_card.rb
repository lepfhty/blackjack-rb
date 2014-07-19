require 'test_helper'

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
    assert_equal :J, @cards[9].value
    assert_equal 10, @cards[9].num_value
    assert_equal :Q, @cards[10].value
    assert_equal 10, @cards[10].num_value
    assert_equal :K, @cards[11].value
    assert_equal 10, @cards[11].num_value
    assert_equal :A, @cards[12].value
    assert_equal 11, @cards[12].num_value
  end

  def test_to_s
    assert_equal "A\u2664", Card.new(:A, :spades).to_s
    assert_equal "A\u2665", Card.new(:A, :hearts).to_s
    assert_equal "A\u2666", Card.new(:A, :diamonds).to_s
    assert_equal "A\u2667", Card.new(:A, :clubs).to_s
  end
end
