class Game

  require_relative 'person'
  require_relative 'AI'
  require_relative 'deck'

  # Variables
  attr_accessor :winning_credit_amount
  attr_accessor :player
  attr_accessor :opponent
  attr_accessor :dealer
  attr_accessor :deck

  def initialize(winning_credit_amount)
    @winning_credit_amount = winning_credit_amount
    @player = Person.new('Frank',100)
    @dealer = AI.new('Bob',10000,16)
    @opponent = AI.new('Greg',100,[14,18])
    @deck = Deck.new(1)
  end

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

  def recap_player_credits
    puts "[i] Recap:"
    puts "   - #{@player.name}: #{@player.credits}"
    puts "   - #{@opponent.name}: #{@opponent.credits}"
  end

  def exit_message
    puts "\nThanks for playing!"
    puts "Want to improve or add something?\nYou're welcome to fork this project and contribute\nat www.github.com/MFarmer/Blackjack_Ruby"
    puts ''
  end

  def reset_game
    @player.hand.reset
    @opponent.hand.reset
    @dealer.hand.reset
    @deck.reset(1)
    @player.active_status = true
    @opponent.active_status = true
    @dealer.active_status = true
    enter_to_continue
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

  def perform_turns
    @player.perform_turn(@dealer,@deck)
    enter_to_continue

    @opponent.perform_turn(@deck)
    enter_to_continue

    @dealer.perform_turn(@deck)
    enter_to_continue
  end

  def deal_cards
    puts "\n[!] #{@dealer.name} deals the cards..."

    2.times do
      @player.receive_card(@deck.deal_card)
      @opponent.receive_card(@deck.deal_card)
      @dealer.receive_card(@deck.deal_card)
    end

    @player.hand.description
    @opponent.hand.description
    @dealer.hand.semi_discrete_description
  end

  def check_win_conditions
    determine_active_status_from_hand_value(@player)
    determine_active_status_from_hand_value(@opponent)
    determine_active_status_from_hand_value(@dealer)

    if @dealer.active_status
      determine_game_payout_for(@player)
      determine_game_payout_for(@opponent)
    else
      # House busted. Are there any players with active hands?
      if @player.active_status
        win_bet(@player)
      end

      if @opponent.active_status
        win_bet(@opponent)
      end

      if !@player.active_status && !@opponent.active_status
        # everyone busted
        puts "[!] House and #{@opponent.name} have pushed. #{@opponent.recent_bet} credit bet is returned."
        @opponent.credits += @opponent.recent_bet
      end
    end

    # Has somebody won the game yet?
    if @player.credits >= @winning_credit_amount && @opponent.credits < @player.credits || @player.credits > 0 && @opponent.credits <= 0
      puts "\n[!] CONGRATULATIONS, you have beaten #{@opponent.name}!"
      recap_player_credits
      return true
    elsif @opponent.credits >= @winning_credit_amount && @player.credits < @opponent.credits || @opponent.credits > 0 && @player.credits <= 0
      puts "\n[!] Sorry, but #{@opponent.name} has beaten you."
      recap_player_credits
      return true
    end
    return false
  end

  def accept_bets
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
  end

  def determine_game_payout_for(person)
    if person.active_status && person.hand.highest_value > @dealer.hand.highest_value
      win_bet(person)
    elsif person.active_status && person.hand.highest_value == @dealer.hand.highest_value
      push_bet(person)
    else
      puts "[!] House has beaten #{person.name}'s hand. (-#{person.recent_bet} credits)"
    end
  end

  def determine_active_status_from_hand_value(person)
    if person.hand.highest_value <= 21
      person.active_status = true
    end
  end

  def win_bet(person)
    puts "[!] #{person.name} has beaten the house. (#{person.recent_bet*2} credit payout)"
    person.credits += person.recent_bet * 2
  end

  def push_bet(person)
    puts "[!] House and #{person.name} have pushed. #{person.recent_bet} credit bet is returned."
    person.credits += person.recent_bet
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
    puts "\n[!] Let's begin!"
  end

end