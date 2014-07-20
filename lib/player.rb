require 'console_prompter'

class Player
  attr_reader :name, :hands, :bankroll, :total_bet

  def initialize(name, prompter = ConsolePrompter.new)
    @name = name
    @hands = []
    @active = nil
    @bankroll = 100
    @increment = 0
    @total_bet = 0
    @prompter = prompter
  end

  def to_s
    str = "#{@name} - Bal: $#{@bankroll}, Total Bet: $#{@total_bet}\n"
    @hands.reduce(str) do |str, hand|
      str << (active_hand == hand ? '* ' : '  ') << hand.to_s << "\n"
    end
    str
  end

  def deal(hand)
    raise 'Must bet before being dealt!' if @total_bet == 0
    hand.bet = @increment
    @hands << hand
    @active = 0
  end

  def active_hand
    @hands[@active]
  end

  def initial_bet(amount = nil)
    if amount.nil?
      amount = @prompter.prompt_bet @name, @bankroll
    end
    @increment = amount
    @total_bet = amount
    @bankroll -= amount
    @increment
  end

  # stands on active hand
  # moves to next hand
  def stand!
    active_hand.stand!
    check_done
  end

  # hits on active hand
  # move to next hand if bust or twentyone
  def hit!(card)
    active_hand.hit! card
    check_done
  end

  # increases bet
  # doubles on active hand
  # moves to next hand
  def double!(card)
    increase_bet
    active_hand.double! card
    check_done
  end

  # increases bet
  # splits on active hand
  # updates list of hands
  # sets active hand to first split hand
  def split!(card1, card2)
    increase_bet

    h1, h2 = active_hand.split!(card1, card2)
    @hands.delete_at @active
    @hands.insert @active, h1, h2

    check_done
  end

  # adds payout of all remaining hands after comparing to dealer hand
  # resets bet
  def payout(dealer_hand)
    win = @hands.reduce(0) do |winnings, hand|
      winnings += hand.payout(dealer_hand)
    end
    @bankroll += win
    @increment = 0
    @total_bet = 0
    @hands = []
    win
  end

  def increase_bet
    raise 'Not enough funds!' if @bankroll < @increment
    @total_bet += @increment
    @bankroll -= @increment
  end

  def check_done
    @active += 1 if active_hand.done?
    @active < @hands.size
  end

  def take_action(deck)
    return stand! if active_hand.blackjack?
    action = @prompter.prompt_action active_hand, @increment, @bankroll
    case action
    when 'd'
      double! deck.deal!
    when 'p'
      split! deck.deal!, deck.deal!
    when 'h'
      hit! deck.deal!
    when 's'
      stand!
    end
  end

end
