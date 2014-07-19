class Player
  attr_reader :name, :hands, :bankroll, :total_bet

  def initialize(name)
    @name = name
    @hands = []
    @active = nil
    @bankroll = 100
    @increment = 0
    @total_bet = 0
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
      amount = prompt_bet
    end
    @increment = amount
    @total_bet = amount
    @bankroll -= amount
    @increment
  end

  def prompt_bet
    bet = 0
    valid = false
    begin
      puts "#{@name}, place your bet, 0 to sit."
      puts "Bal: $#{@bankroll}"
      bet = gets.chomp
      valid = (Float(bet) == bet.to_i && bet.to_i > -1) rescue false
      if bet.to_i > @bankroll
        puts 'Insufficient funds!'
        valid = false
      end
      puts 'Invalid bet!' unless valid
    end until valid
    bet.to_i
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
    puts active_hand
    return stand! if active_hand.blackjack?
    action = prompt_action
    case action
    when 'd'
      puts "#{name} doubles."
      double! deck.deal!
    when 'p'
      puts "#{name} splits."
      split! deck.deal!, deck.deal!
    when 'h'
      puts "#{name} hits."
      hit! deck.deal!
    when 's'
      puts "#{name} stands."
      stand!
    end
  end

  def prompt_action
    action = nil
    actions = valid_actions
    begin
      puts actions.map { |k,v| "#{k} = #{v}" }.join("\n")
      puts '--'
      action = gets.chomp
      valid = actions.keys.include? action
      puts 'Invalid action!' unless valid
    end until valid
    action
  end

  def valid_actions
    actions = {}
    actions['d'] = 'Double' if active_hand.doubleable?
    actions['p'] = 'Split' if active_hand.splittable?
    actions['h'] = 'Hit' if active_hand.hittable?
    actions['s'] = 'Stand'
    actions
  end

end
