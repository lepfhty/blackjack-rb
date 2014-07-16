require 'card'

class Deck

  def initialize(num = 1, reshuffle_pct = 0.2)
    @num_decks = num
    @reshuffle_pct = reshuffle_pct
    reshuffle!
  end

  def deal!
    card = @cards.pop
    reshuffle! if size <= 52 * @num_decks * @reshuffle_pct
    card
  end

  def size
    @cards.size
  end

  def reshuffle!(seed = nil)
    if @cards
      puts "#{size} cards left."
    end
    puts "Reshuffling ..."

    @cards = []
    @num_decks.times do
      Card::VALUES.each do |v|
        Card::SUITS.each do |s|
          @cards << Card.new(v,s)
        end
      end
      if seed.nil?
        @cards.shuffle!
      else
        @cards.shuffle! Random.new(seed)
      end
    end
  end

end
