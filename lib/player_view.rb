require 'player'
require 'hand_view'

class PlayerView
  include Indent

  def initialize(player)
    @player = player
    @spaces = ''
  end

  def indent
    @spaces << '  '
  end

  def apply_indent(str)
    str.gsub(/^/, @spaces)
  end

  def summary
    str = "#{header}\n  #{bank}"
    str << "\n  #{total_bet}" if @player.total_bet > 0
    str << "\n#{hands}" unless @player.hands.empty?
    str << "\n#{footer}"
    apply_indent str
  end

  def header
    "#--- #{@player.name} ---#"
  end

  def footer
    "##{'-' * (@player.name.size+8)}#"
  end

  def bank
    "Bal$: %3.f" % @player.bankroll
  end

  def total_bet
    "Bet$: %3.f" % @player.total_bet
  end

  def hands
    @player.hands.map do |h|
      hv = HandView.new(h)
      hv.indent
      hv.summary
    end.join("\n")
  end

end

require 'deck'
require 'hand'

d = Deck.new
pl = Player.new('Bob')
pl.initial_bet(2)
pl.deal Hand.new(d.deal!, d.deal!)
pl.hands << Hand.new(d.deal!, d.deal!)
pv = PlayerView.new pl
puts pv.summary

puts HandView.new(pl.hands[0]).prompt_actions(pl.bankroll)
