class ConstantAction
  def initialize(action)
    @action = action
  end
  def prompt_action(hand, inc, bank)
    @action
  end
end

class MockDeck
  def initialize(*cards)
    @cards = cards
  end
  def deal!
    @cards.shift
  end
end
