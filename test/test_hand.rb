require 'test_helper'

require 'card'
require 'hand'

class TestHand < Minitest::Test
  def setup
    # @cards[n].num_value == n
    @cards = Hash[
      Card::VALUES.map do |v|
        c = Card.new(v,:clubs)
        [c.num_value, c]
      end
    ]
    @h5 = Hand.new(@cards[2], @cards[3])
    @hsoft14 = Hand.new(@cards[11], @cards[3])
    @hsoft20 = Hand.new(@cards[11], @cards[9])
    @hbj = Hand.new(@cards[11], @cards[10])
    @hsoft16hit = Hand.new(@cards[11], @cards[2]).hit!(@cards[3])
    @hhard12hit = Hand.new(@cards[11], @cards[2]).hit!(@cards[9])
    @hdouble9 = Hand.new(@cards[2], @cards[3]).double!(@cards[4])
    @hbust = Hand.new(@cards[9], @cards[8]).hit!(@cards[7])
    @hpair = Hand.new(@cards[8], @cards[8])
    @haces = Hand.new(@cards[11], @cards[8]).hit!(@cards[11]).hit!(@cards[2])
  end

  def test_hands_total
    assert_equal 5, @h5.total
    assert_equal 14, @hsoft14.total
    assert_equal 20, @hsoft20.total
    assert_equal 21, @hbj.total
    assert_equal 16, @hsoft16hit.total
    assert_equal 12, @hhard12hit.total
    assert_equal 9, @hdouble9.total
    assert_equal 24, @hbust.total
    assert_equal 16, @hpair.total
    assert_equal 12, @haces.total
  end

  def test_hands_to_s
    str = @hsoft16hit.to_s
    assert str.include?(@cards[11].to_s)
    assert str.include?(@cards[2].to_s)
    assert str.include?(@cards[3].to_s)
    assert str.include?('soft')
    assert str.include?('16')

    str = @hbj.to_s
    assert str.include?(@cards[11].to_s)
    assert str.include?(@cards[10].to_s)
    assert !str.include?('soft')
    assert str.include?('21')

    str = @hhard12hit.to_s
    assert str.include?(@cards[11].to_s)
    assert str.include?(@cards[2].to_s)
    assert str.include?(@cards[9].to_s)
    assert !str.include?('soft')
    assert str.include?('12')
  end

  def test_hittable
    assert [@h5, @hsoft14, @hsoft20, @hsoft16hit, @hhard12hit].all? { |h| h.hittable? }
    assert [@hbj, @hdouble9, @hbust].all? { |h| !h.hittable? }
  end

  def test_doubleable
    assert [@h5, @hsoft14, @hsoft20].all? { |h| h.doubleable? }
    assert [@hbj, @hsoft16hit, @hhard12hit, @hdouble9, @hbust].all? { |h| !h.doubleable? }
  end

  def test_splittable
    assert [@h5, @hsoft14, @hsoft20, @hbj, @hsoft16hit, @hhard12hit, @hdouble9, @hbust].all? { |h| !h.splittable? }
    assert @hpair.splittable?
  end

  def test_done
    assert [@h5, @hsoft14, @hsoft20, @hsoft16hit, @hhard12hit, @hpair].all? { |h| !h.done? }
    assert [@hbj, @hdouble9, @hbust].all? { |h| h.done? }
  end

  def test_bust
    assert @hbust.bust?
  end

  def test_twentyone
    assert @hbj.twentyone?
  end

  def test_blackjack
    assert @hbj.blackjack?
  end

  def test_payout_bust
    assert_equal 0, @hbust.payout(@hbust)
    assert_equal 0, @hbust.payout(@h5)
  end

  def test_payout_dealer_bj
    assert_equal 1, @hbj.payout(@hbj)
    assert_equal 0, @h5.payout(@hbj)
    assert_equal 0, @hbust.payout(@hbj)
  end

  def test_payout_bj
    assert_equal 2.5, @hbj.payout(@h5)
    assert_equal 2.5, @hbj.payout(@hbust)
    assert_equal 1, @hbj.payout(@hbj)
  end

  def test_double_bet
    assert_equal 2, @hdouble9.bet
  end

  def test_payout_push
    [@h5, @hsoft14, @hsoft20, @hbj, @hsoft16hit, @hhard12hit, @hdouble9, @hpair].each do |h|
      assert_equal h.bet, h.payout(h), h.to_s
    end
    assert_equal 0, @hbust.payout(@hbust)
  end

  def test_payout_unequal
    assert_equal 0, @h5.payout(@hsoft14)
    assert_equal 2, @hsoft14.payout(@h5)
  end

  def test_payout_double
    assert_equal 4, @hdouble9.payout(@h5)
    assert_equal 0, @hdouble9.payout(@hsoft14)
    assert_equal 2, @hdouble9.payout(@hdouble9)
  end

  def test_split
    h1, h2 = @hpair.split!(@cards[3], @cards[4])
    assert_equal 11, h1.total
    assert_equal 1, h1.bet
    assert_equal 12, h2.total
    assert_equal 1, h2.bet
  end

  def test_split_bet
    @hpair.bet = 8
    h1, h2 = @hpair.split!(@cards[3], @cards[4])
    assert_equal 11, h1.total
    assert_equal 8, h1.bet
    assert_equal 12, h2.total
    assert_equal 8, h2.bet
  end

end
