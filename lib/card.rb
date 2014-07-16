class Card
  include Comparable
  attr_reader :value, :suit

  SUITS = [ :clubs, :diamonds, :hearts, :spades ]
  VALUES = [ 2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A ]

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def <=>(other)
    comp_value <=> other.comp_value
  end

  def to_s
    case @suit
    when :spades
      "%2s\u2664"
    when :hearts
      "%2s\u2665"
    when :diamonds
      "%2s\u2666"
    when :clubs
      "%2s\u2667"
    end % @value.to_s
  end

  def comp_value
    case @value
    when :J
      11
    when :Q
      12
    when :K
      13
    when :A
      14
    else
      @value
    end
  end

  def num_value
    case @value
    when :J, :Q, :K
      10
    when :A
      11
    else
      @value
    end
  end

end
