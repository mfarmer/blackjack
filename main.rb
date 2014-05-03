require_relative 'game'

game = Game.new(150)

# Begin the game

game.display_intro

game.determine_player_names

game.print_game_rules

# Start of game loop

while true
  puts "\n[!] Dealer #{game.dealer.name} says: \"Place your bets...\""

  puts "\n[?] What is your bet? (Enter an integer between 1 and 10, inclusive)."
  puts "[i] Your Credit Balance: #{game.player.credits}"
  print "==> "
  game.player.recent_bet = STDIN.gets.chomp.to_i

  while game.player.recent_bet < 1 || game.player.recent_bet > 10
    puts "\n[?] Invalid bet. Please enter a number from 1 to 10."
    print "==> "
    game.player.recent_bet = STDIN.gets.chomp.to_i
  end

  game.player.credits -= game.player.recent_bet

  puts "\n[!] #{game.player.name} bets #{game.player.recent_bet} credits."
  puts "[!] #{game.opponent.name} bets #{game.opponent.make_bet} credits."

  puts "\n[!] #{game.dealer.name} deals the cards..."

  game.deal_cards

  game.player.perform_turn(game.dealer,game.deck)
  game.enter_to_continue

  game.opponent.perform_turn(game.deck)
  game.enter_to_continue
  
  game.dealer.perform_turn(game.deck)
  game.enter_to_continue

  # Check win conditions
  game.determine_active_status_from_hand_value(game.player)
  game.determine_active_status_from_hand_value(game.opponent)
  game.determine_active_status_from_hand_value(game.dealer)

  if game.dealer.active_status
    game.determine_game_payout_for(game.player)
    game.determine_game_payout_for(game.opponent)
  else
    # House busted. Are there any players with active hands?
    if game.player.active_status
      game.win_bet(game.player)
    end

    if game.opponent.active_status
      win_bet(game.opponent)
    end

    if !game.player.active_status && !game.opponent.active_status
      # everyone busted
      puts "[!] House and #{game.opponent.name} have pushed. #{game.opponent.recent_bet} credit bet is returned."
      game.opponent.credits += game.opponent.recent_bet
    end
  end

  # Has somebody won the game yet?
  if game.player.credits >= game.winning_credit_amount && game.opponent.credits < game.player.credits || game.player.credits > 0 && game.opponent.credits <= 0
    puts "\n[!] CONGRATULATIONS, you have beaten #{@opponent.name}!"
    game.recap_player_credits
    break
  elsif game.opponent.credits >= game.winning_credit_amount && game.player.credits < game.opponent.credits || game.opponent.credits > 0 && game.player.credits <= 0
    puts "\n[!] Sorry, but #{game.opponent.name} has beaten you."
    game.recap_player_credits
    break
  end

  game.recap_player_credits

  # Reset game
  game.reset_game

  game.enter_to_continue
end

game.exit_message





