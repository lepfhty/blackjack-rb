class Player
  attr_reader :hands, :bankroll, :total_bet

  def initialize
    @hands = []
    @active = nil
    @bankroll = 100
    @increment = 0
    @total_bet = 0
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

  def initial_bet(amount = 1)
    @increment = amount
    @total_bet = amount
    @bankroll -= amount
  end

  # stands on active hand
  # moves to next hand
  # returns true if no more hands
  def stand!
    active_hand.stand!
    check_done
  end

  # hits on active hand
  # move to next hand if bust or twentyone
  # returns true if no more hands
  def hit!(card)
    active_hand.hit! card
    check_done
  end

  # increases bet
  # doubles on active hand
  # moves to next hand
  # returns true if no more hands
  def double!(card)
    increase_bet
    active_hand.double!(card)
    check_done
  end

  # increases bet
  # splits on active hand
  # updates list of hands
  # sets active hand to first split hand
  # moves to next hand
  # returns true if no more hands
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
  end

  def increase_bet
    raise 'Not enough funds!' if @bankroll < @increment
    @total_bet += @increment
    @bankroll -= @increment
  end

  # if active_hand busted, delete hand
  # if active_hand blackjack, immediate payout, delete hand
  # if active_hand done (stand/double), move to next hand
  # return true if no more hands
  def check_done
    if active_hand.done?
      if active_hand.bust?
        @hands.delete_at @active
      elsif active_hand.blackjack?
        @bankroll += 2.5 * active_hand.bet
        @hands.delete_at @active
      else
        @active += 1
      end
    end
    @active >= @hands.size
  end

end
