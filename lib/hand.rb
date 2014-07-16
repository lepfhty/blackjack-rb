class Hand
  attr_reader :bet, :cards, :total

  def initialize(card1, card2, bet = 1)
    @cards = []
    @ace = false
    @bet = bet
    @done = false
    @soft = false
    hit!(card1)
    hit!(card2)
  end

  def to_s
    @cards.map(&:to_s).join(' ') + (@soft ? ' (soft %d)' : ' (%d)') % @total
  end

  def hit!(card)
    @cards << card
    @ace ||= (card.value == :A)
    @total = @cards.reduce(0) do |s, card|
      s += card.num_value
    end
    @soft = @ace && @total < 21
    @total -= 10 if (@ace && @total > 21 && @total <= 31)
    self
  end

  def double!(card)
    @bet *= 2
    @done = true
    hit!(card)
  end

  def split!(card1, card2)
    h1 = Hand.new(@cards[0], card1, @bet)
    h2 = Hand.new(@cards[1], card2, @bet)
    @done = true
    [h1, h2]
  end

  def payout(dealer_hand)
    if bust? or (!dealer_hand.bust? && dealer_hand.total > @total)
      -@bet
    elsif blackjack? && !dealer_hand.blackjack?
      2.5 * @bet
    elsif dealer_hand.bust? or dealer_hand.total < @total
      2 * @bet
    elsif dealer_hand.total == @total
      @bet
    end
  end

  def done?
    # double! might have set @done = true
    @done = true if bust? or twentyone?
    @done
  end

  def bust?
    @total > 21
  end

  def twentyone?
    @total == 21
  end

  def blackjack?
    twentyone? and @cards.size == 2
  end

  def hittable?
    !done? && @total < 21
  end

  def doubleable?
    !twentyone? and @cards.size == 2
  end

  def splittable?
    @cards.size == 2 && @cards[0].value == @cards[1].value
  end

end
