require 'test_helper'

require 'console_prompter'

class TestConsolePrompter < Minitest::Test
  def setup
    @prompter = ConsolePrompter.new
    @hpair = Hand.new(Card.new(8, :clubs), Card.new(8, :spades))
    @hlow = Hand.new(Card.new(3, :clubs), Card.new(2, :clubs))
    @hhit = Hand.new(Card.new(3, :clubs), Card.new(2, :clubs)).hit!(Card.new(4, :clubs))
    @hbust = Hand.new(Card.new(:K, :clubs), Card.new(:Q, :clubs)).hit!(Card.new(:J, :clubs))
    @h21 = Hand.new(Card.new(:A, :clubs), Card.new(:Q, :clubs))
  end

  def test_valid_bet
    assert_equal @prompter.validate_bet('20', 20), 20
    assert_equal @prompter.validate_bet('10', 20), 10
    assert !@prompter.validate_bet('asdf', 20)
    assert !@prompter.validate_bet('30', 20)
    assert !@prompter.validate_bet('-1', 20)
    assert !@prompter.validate_bet('1.34', 20)
    assert !@prompter.validate_bet('-1.34', 20)
    assert !@prompter.validate_bet('1e1', 20)
  end

  def test_valid_actions
    assert_equal @prompter.valid_actions(@hpair, 1, 1).keys, %w[d p h s]
    assert_equal @prompter.valid_actions(@hlow, 1, 1).keys, %w[d h s]
    assert_equal @prompter.valid_actions(@hhit, 1, 1).keys, %w[h s]
    assert_equal @prompter.valid_actions(@hbust, 1, 1).keys, %w[]
    assert_equal @prompter.valid_actions(@h21, 1, 1).keys, %w[s]
  end

  def test_valid_actions_bankroll
    assert_equal @prompter.valid_actions(@hpair, 2, 1).keys, %w[h s]
    assert_equal @prompter.valid_actions(@hlow, 2, 1).keys, %w[h s]
    assert_equal @prompter.valid_actions(@hhit, 2, 1).keys, %w[h s]
    assert_equal @prompter.valid_actions(@hbust, 2, 1).keys, %w[]
    assert_equal @prompter.valid_actions(@h21, 2, 1).keys, %w[s]
  end
end
