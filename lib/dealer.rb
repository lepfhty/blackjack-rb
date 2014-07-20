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

  def take_action(deck, console = true)
    puts active_hand if console
    if @hand.total < 17 or (@hand.soft? && @hand.total == 17)
      puts "#{@name} hits." if console
      @hand.hit! deck.deal!
    elsif @hand.total > 21
      puts "#{@name} busts." if console
    else
      puts "#{@name} stands." if console
      @hand.stand!
    end
    !@hand.done?
  end

end
