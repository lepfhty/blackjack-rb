require 'card'
require 'logger'

class Deck
  def initialize(num = 1)
    @num_decks = num
    reshuffle!
  end

  def deal!
    raise 'All cards dealt!' if @cards.empty?
    @cards.pop
  end

  def size
    @cards.size / 52.0 / @num_decks
  end

  def reshuffle!(seed = nil)
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
