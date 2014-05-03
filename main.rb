require_relative 'person'
require_relative 'AI'
require_relative 'deck'

# Variables
@winning_credit_amount = 150
@player = Person.new('Frank',100)
@dealer = AI.new('Bob',10000,16)
@opponent = AI.new('Greg',100,[14,18])
@deck = Deck.new(1)

def enter_to_continue
  puts "\n   >>> Press 'Enter' to continue <<<"
  STDIN.gets.chomp()
end

def display_intro
  puts "\n+----------------------------+"
  puts "|          BlackJack         |"
  puts "+----------------------------+\n"

  puts "\n[!] Welcome to BlackJack. Let's setup the game..."
end

def determine_player_names
  puts "\n[?] First, what is your name?"
  print "==> "
  @player.name = STDIN.gets.chomp.capitalize

  puts "\n[!] Thanks, #{@player.name}."

  if @opponent.name == @player.name
    @opponent.name = 'Jack'
  end

  if @dealer.name == @player.name
    @dealer.name = 'George'
  end
end

def print_game_rules
  puts "\n[i] Game Information"
  puts "   - Your dealer today will be #{@dealer.name}."
  puts "   - You are playing alongside #{@opponent.name}."
  puts "   - #{@opponent.name} is a fairly new BlackJack player."
  puts "   - Both you and #{@opponent.name} are starting with 100 credits."
  puts "   - Let's see which of you will increase your credits to #{@winning_credit_amount} first."
  puts "   - If one of you loses all of your credits, the other player wins."
  puts "   - The minimum bet is 1 credit, and the maximum bet is 10 credits."
end

# Begin the game

display_intro

determine_player_names

print_game_rules

puts "\n[!] Let's begin!"

# Start of game loop

while true
  puts "\n[!] Dealer #{@dealer.name} says: \"Place your bets...\""

  puts "\n[?] What is your bet? (Enter an integer between 1 and 10, inclusive)."
  puts "[i] Your Credit Balance: #{@player.credits}"
  print "==> "
  @player.recent_bet = STDIN.gets.chomp.to_i

  while @player.recent_bet < 1 || @player.recent_bet > 10
    puts "\n[?] Invalid bet. Please enter a number from 1 to 10."
    print "==> "
    @player.recent_bet = STDIN.gets.chomp.to_i
  end

  @player.credits -= @player.recent_bet

  puts "\n[!] #{@player.name} bets #{@player.recent_bet} credits."
  puts "[!] #{@opponent.name} bets #{@opponent.make_bet} credits."

  puts "\n[!] #{@dealer.name} deals the cards..."

  2.times do
    @player.receive_card(@deck.deal_card)
    @opponent.receive_card(@deck.deal_card)
    @dealer.receive_card(@deck.deal_card)
  end

  @player.hand.description
  @opponent.hand.description
  @dealer.hand.semi_discrete_description

  while @player.active_status

    puts "\n[i] Dealer #{@dealer.name} asks: \"What would you like to do?\""
    puts "[?] Please enter the corresponding integer for your choice (1-2, inclusive)"
    @player.hand.possible_values_inline
    puts "    1) Hold"
    puts "    2) Hit"
    print "==> "
    choice = STDIN.gets.chomp.to_i

    while choice < 1 || choice > 2
      puts "[!] Invalid choice. Please enter a value between 1-2 inclusive that corresponds with your choice below."
      puts "[i] 1) Hold 2) Hit"
      print "==> "
      choice = STDIN.gets.chomp.to_i
    end

    if choice == 1
      puts "\n[i] #{@player.name} is holding at #{@player.hand.highest_value}"
      @player.active_status = false
    else
      puts "\n[i] #{@player.name} is hitting."
      @player.receive_card(@deck.deal_card)
      @player.hand.description
    end
  end

  enter_to_continue

  # Opponent's turn
  limit = rand(@opponent.hold_amount[0]..@opponent.hold_amount[@opponent.hold_amount.count-1])

  while @opponent.hand.highest_value < limit
    puts "\n[i] #{@opponent.name} is hitting."
    @opponent.receive_card(@deck.deal_card)
    @opponent.hand.description
  end

  if @opponent.active_status
    puts "\n[i] #{@opponent.name} is holding at #{@opponent.hand.highest_value}"
  end

  enter_to_continue

  # Dealer's turn
  limit = @dealer.hold_amount
  while @dealer.hand.highest_value < limit
    puts "\n[i] #{@dealer.name} is hitting."
    @dealer.receive_card(@deck.deal_card)
    @dealer.hand.description
  end

  if @dealer.active_status
    puts "\n[i] #{@dealer.name} is holding at #{@dealer.hand.highest_value}"
  end

  enter_to_continue

  # Check win conditions
  if @player.hand.highest_value <= 21
    @player.active_status = true
  end

  if @opponent.hand.highest_value <= 21
    @opponent.active_status = true
  end

  if @dealer.hand.highest_value <= 21
    @dealer.active_status = true
  end

  if @dealer.active_status

    if @player.active_status && @player.hand.highest_value > @dealer.hand.highest_value
      puts "[!] #{@player.name} has beaten the house. (#{@player.recent_bet*2} credit payout)"
      @player.credits += @player.recent_bet * 2
    elsif @player.active_status && @player.hand.highest_value == @dealer.hand.highest_value
      puts "[!] House and #{@player.name} have pushed. #{@player.recent_bet} credit bet is returned."
      @player.credits += @player.recent_bet
    else
      puts "[!] House has beaten #{@player.name}'s hand. (-#{@player.recent_bet} credits)"
    end

    if @opponent.active_status && @opponent.hand.highest_value > @dealer.hand.highest_value
      puts "[!] #{@opponent.name} has beaten the house. (#{@opponent.recent_bet*2} credit payout)"
      @opponent.credits += @opponent.recent_bet * 2
    elsif @opponent.active_status && @opponent.hand.highest_value == @dealer.hand.highest_value
      puts "[!] House and #{@opponent.name} have pushed. #{@opponent.recent_bet} credit bet is returned."
      @opponent.credits += @opponent.recent_bet
    else
      puts "[!] House has beaten #{@opponent.name}'s hand. (-#{@opponent.recent_bet} credits)"
    end
  else
    # House busted. Are there any players with active hands?
    if @player.active_status
      puts "[!] #{@player.name} has beaten the house. (#{@player.recent_bet*2} credit payout)"
      @player.credits += @player.recent_bet * 2
    end

    if @opponent.active_status
      puts "[!] House and #{@player.name} have pushed. #{@player.recent_bet} credit bet is returned."
      @player.credits += @player.recent_bet
      puts "[!] #{@opponent.name} has beaten the house. (#{@opponent.recent_bet*2} credit payout)"
      @opponent.credits += @opponent.recent_bet * 2
    end

    if !@player.active_status && !@opponent.active_status
      # everyone busted
      puts "[!] House and #{@opponent.name} have pushed. #{@opponent.recent_bet} credit bet is returned."
      @opponent.credits += @opponent.recent_bet
    end
  end

  # Has somebody won the game yet?
  if @player.credits >= @winning_credit_amount && @opponent.credits < @player.credits || @player.credits > 0 && @opponent.credits <= 0
    puts "[!] CONGRATULATIONS, you have beaten #{@opponent.name}!"
    puts "[i] Recap:"
    puts "   - #{@player.name}: #{@player.credits} credits"
    puts "   - #{@opponent.name}: #{@opponent.credits} credits"
    break
  elsif @opponent.credits >= @winning_credit_amount && @player.credits < @opponent.credits || @opponent.credits > 0 && @player.credits <= 0
    puts "\n[!] Sorry, but #{@opponent.name} has beaten you."
    puts "[i] Recap:"
    puts "   - #{@player.name}: #{@player.credits} credits"
    puts "   - #{@opponent.name}: #{@opponent.credits} credits"
    break
  end

  puts "[i] Recap:"
  puts "   - #{@player.name}: #{@player.credits}"
  puts "   - #{@opponent.name}: #{@opponent.credits}"

  # Reset game
  @player.hand.reset
  @opponent.hand.reset
  @dealer.hand.reset
  @deck.reset(1)
  @player.active_status = true
  @opponent.active_status = true
  @dealer.active_status = true

  enter_to_continue
end

puts "\nThanks for playing!"
puts "Want to improve or add something?\nYou're welcome to fork this project and contribute\nat www.github.com/MFarmer/Blackjack_Ruby"
puts ''





