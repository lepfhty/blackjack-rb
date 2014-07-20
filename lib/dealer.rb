class Dealer
  attr_reader :name

  def initialize
    @name = 'Dealer'
  end

  def to_s
    "#{name}: #{@hand}"
  end

  def deal(hand)
    @hand = hand
  end

  def active_hand
    @hand
  end

  def faceup_card
    @hand.cards[0]
  end

  def take_action(deck)
    puts active_hand
    if @hand.total < 17 or (@hand.soft? && @hand.total == 17)
      puts "#{@name} hits."
      @hand.hit! deck.deal!
    elsif @hand.total > 21
      puts "#{@name} busts."
    else
      puts "#{@name} stands."
      @hand.stand!
    end
    @hand.done?
  end

end
