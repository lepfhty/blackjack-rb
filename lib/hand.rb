class Hand
  attr_accessor :bet
  attr_reader :cards, :total

  def initialize(card1, card2)
    @cards = []
    @ace = false
    @bet = 1
    @done = false
    @soft = false
    @total = 0
    hit!(card1)
    hit!(card2)
  end

  def to_s
    @cards.map(&:to_s).join(' ') + (@soft ? ' (soft %d)' : ' (%d)') % @total
  end

  def hit!(card)
    raise "Cannot hit this hand: #{to_s}" unless hittable?
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
    raise "Cannot double this hand: #{to_s}" unless doubleable?
    hit!(card)
    @bet *= 2
    @done = true
    self
  end

  def split!(card1, card2)
    raise "Cannot split this hand: #{to_s}" unless splittable?
    h1 = Hand.new(@cards[0], card1)
    h2 = Hand.new(@cards[1], card2)
    @done = true
    [h1, h2]
  end

  def stand!
    @done = true
  end

  def payout(dealer_hand)
    if bust? or (!dealer_hand.bust? && dealer_hand.total > @total)
      0
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
