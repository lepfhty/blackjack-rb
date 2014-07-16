require 'minitest'
require 'minitest/autorun'

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
  end

  def test_hands_total
    assert_equal @h5.total, 5
    assert_equal @hsoft14.total, 14
    assert_equal @hsoft20.total, 20
    assert_equal @hbj.total, 21
    assert_equal @hsoft16hit.total, 16
    assert_equal @hhard12hit.total, 12
    assert_equal @hdouble9.total, 9
    assert_equal @hbust.total, 24
    assert_equal @hpair.total, 16
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
    assert_equal @hbust.payout(@hbust), -1
    assert_equal @hbust.payout(@h5), -1
  end

  def test_payout_dealer_bj
    assert_equal @hbj.payout(@hbj), 1
    assert_equal @h5.payout(@hbj), -1
    assert_equal @hbust.payout(@hbj), -1
  end

  def test_payout_bj
    assert_equal @hbj.payout(@h5), 2.5
    assert_equal @hbj.payout(@hbust), 2.5
    assert_equal @hbj.payout(@hbj), 1
  end

  def test_double_bet
    assert_equal @hdouble9.bet, 2
  end

  def test_payout_push
    [@h5, @hsoft14, @hsoft20, @hbj, @hsoft16hit, @hhard12hit, @hdouble9, @hpair].each do |h|
      assert_equal h.payout(h), h.bet, h.to_s
    end
    assert_equal @hbust.payout(@hbust), -1
  end

  def test_payout_unequal
    assert_equal @h5.payout(@hsoft14), -1
    assert_equal @hsoft14.payout(@h5), 2
  end

  def test_payout_double
    assert_equal @hdouble9.payout(@h5), 4
    assert_equal @hdouble9.payout(@hsoft14), -2
    assert_equal @hdouble9.payout(@hdouble9), 2
  end

  def test_split
    h1, h2 = @hpair.split!(@cards[3], @cards[4])
    assert_equal h1.total, 11
    assert_equal h1.bet, 1
    assert_equal h2.total, 12
    assert_equal h2.bet, 1
  end

end
