require 'deck'
require 'hand'
require 'player'
require 'dealer'

class ConsoleGame

  class << self
    def prompt_integer(prompt, default, low, high)
      puts "#{prompt} (#{low} to #{high}, default #{default})"
      valid = false
      begin
        str = gets.chomp
        if str.empty?
          value = default
          valid = true
        else
          val_i = str.to_i
          val_f = Float(str) rescue nil
          valid = (val_i == val_f && val_i >= low && val_i <= high)
          value = val_i if valid
        end
      end until valid
      value
    end
  end

  def initialize(num_decks = 1, num_players = 1, reshuffle_fraction = 0.25)
    @deck = Deck.new num_decks
    @dealer = Dealer.new
    @players = (1..num_players).map do |i|
      puts "Enter player #{i} name: "
      Player.new gets.chomp
    end
    @reshuffle_fraction = reshuffle_fraction
  end

  def reshuffle_ifnec
    if @deck.fraction < @reshuffle_fraction
      puts "Reshuffling!"
      @deck.reshuffle!
    end
  end

  def collect_bets
    puts '$--- BETTING ---$'
    @betting_players = @players.select do |player|
      player.initial_bet > 0
    end
    puts '$---------------$'
    puts ''
    @betting_players << @dealer
  end

  def deal_players
    @betting_players.each do |player|
      player.deal Hand.new(@deck.deal!, @deck.deal!)
    end
  end

  def player_turn(player)
    puts "#--- PLAYER: #{player.name} ---#"
    unless player == @dealer
      puts "Dealer showing #{@dealer.faceup_card}"
      puts '--'
    end
    puts 'Select an action for this hand'
    # take_action returns false when player blackjack/busts/stands on all hands
    while player.take_action(@deck)
      puts '--'
      sleep 1
    end
    puts '--'
    puts player
    puts ''
    sleep 1
  end

  def give_payouts
    puts ''
    puts '$--- PAYOUTS ---$'
    puts @dealer
    @betting_players.each do |player|
      unless player == @dealer
        puts player
        bet = player.total_bet
        win = player.payout(@dealer.active_hand)
        puts "  #{ win > 0 ? (win == bet ? "PUSH (#{win})" : "WINS #{win}") : 'LOSES' }"
      end
    end
    puts '$---------------$'
    puts ''
  end

  def run
    while @players.any? { |p| p.bankroll > 0 }
      reshuffle_ifnec

      collect_bets

      deal_players

      unless @dealer.active_hand.blackjack?
        @betting_players.each do |player|
          player_turn player
        end
      end

      give_payouts
    end
  end

end


num_decks = ConsoleGame.prompt_integer 'How many decks?', 1, 1, 8
max_players = [6, num_decks * 2].min
num_players = ConsoleGame.prompt_integer 'How many players?', 1, 1, max_players
ConsoleGame.new(num_decks, num_players, 0.25).run
