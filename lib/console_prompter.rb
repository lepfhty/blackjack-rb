class ConsolePrompter
  def prompt_bet(name, bankroll)
    bet = 0
    valid = false
    begin
      puts "#{name}, place your bet, 0 to sit."
      puts "Bal: $#{bankroll}"
      bet = validate_bet gets.chomp, bankroll
      puts 'Invalid bet!' unless bet
    end until bet
    bet
  end

  def validate_bet(betstring, bankroll)
    bet_i = betstring.to_i
    bet_f = Float(betstring)
    bet_i if bet_i == bet_f && bet_i > -1 && bet_i <= bankroll
  rescue
    false
  end

  def prompt_action(hand, increment, bankroll)
    puts hand
    action = nil
    actions = valid_actions(hand, increment, bankroll)
    begin
      puts actions.map { |k,v| "#{k} = #{v}" }.join("\n")
      puts '--'
      action = gets.chomp.downcase
      valid = actions.has_key? action
      puts 'Invalid action!' unless valid
    end until valid
    puts "=> #{actions[action]}"
    action
  end

  def valid_actions(hand, increment, bankroll)
    actions = {}
    if increment <= bankroll
      actions['d'] = 'Double' if hand.doubleable?
      actions['p'] = 'Split' if hand.splittable?
    end
    actions['h'] = 'Hit' if hand.hittable?
    actions['s'] = 'Stand' unless hand.bust?
    actions
  end

end
