require_relative 'game'

game = Game.new(150)

# Begin the game

game.display_intro

game.determine_player_names

game.print_game_rules

# Start of game loop
while true
  game.accept_bets

  game.deal_cards

  game.perform_turns

  # Check win conditions
  if game.check_win_conditions
    break
  end

  game.recap_player_credits

  # Reset game
  game.reset_game
end

game.exit_message





