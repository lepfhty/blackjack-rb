class PlayerController
  def initialize(player, deck)
    @player = player
    @deck = deck
  end

  def hit!
    @player.active_hand.hit! @deck.deal!
  end
end
