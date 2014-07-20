require 'indent'

class HandAction
  attr_reader :key, :label, :method
  def initialize(key, label, method)
    @key = key
    @label = label
    @method = method
  end
  DOUBLE = HandAction.new('d', 'Double', :double!)
  SPLIT = HandAction.new('p', 'Split', :split!)
  HIT = HandAction.new('h', 'Hit', :hit!)
  STAND = HandAction.new('s', 'Stand', :stand!)
end

class HandView
  include Indent

  def initialize(hand)
    @hand = hand
    @spaces = ''
  end

  def total
    "(#{@hand.soft? ? 'soft ' : ''}#{@hand.total})"
  end

  def bet
    "Bet$: %3.f" % @hand.bet
  end

  def summary
    str = "Hand: #{short}\n  #{bet}"
    apply_indent str
  end

  def short
    @hand.cards.map { |c| c.to_s }.join('  ') << "  #{total}"
  end

  def actions(bankroll)
    h = {}
    if @hand.bet <= bankroll
      h[HandAction::DOUBLE.key] = HandAction::DOUBLE if @hand.doubleable?
      h[HandAction::SPLIT.key] = HandAction::SPLIT if @hand.splittable?
    end
    h[HandAction::HIT.key] = HandAction::HIT if @hand.hittable?
    h[HandAction::STAND.key] = HandAction::STAND unless @hand.bust?
    h
  end

  def prompt_actions(bankroll)
    short << "\n" << actions(bankroll).map { |k,v| "#{k} = #{v.label}" }.join("\n")
  end
end
