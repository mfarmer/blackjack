class Person

  attr_accessor :name
  attr_accessor :credits
  attr_accessor :hand
  attr_accessor :active_status
  attr_accessor :recent_bet

  class Hand

    attr_accessor :cards

    def initialize(player)
      @player = player
      @cards = []
    end

    def description
      puts "\n[i] #{@player.name} has the following cards:"
      @cards.each do |card|
        puts card.description
      end

      puts "-------------------"
      possible_values

      value_check
    end

    def reset
      @cards = []
    end

    def possible_values
      if max_value == min_value
        puts "   - [#{max_value}] max value"
      else
        puts "   - [#{max_value}] max value"
        puts "   - [#{min_value}] min value"
      end
    end

    def possible_values_inline
      if max_value == min_value
        puts "    >>> Your hand is worth #{highest_value} <<<"
      else
        puts "    >>> Your hand is worth #{max_value} or #{min_value} <<<"
      end
    end

    def semi_discrete_description
      puts "\n[i] #{@player.name} has the following cards:"
      puts @cards[0].description
      puts "   - [??] Hidden Card"
    end

    def value_check
      if max_value > 21 && min_value > 21
        puts "   - #{@player.name} has busted!"
        @player.active_status = false
      elsif max_value == 21 || min_value == 21
        puts "   - BLACKJACK!!! Way to go."
        @player.active_status = false
      end
    end

    def max_value
      value = 0
      @cards.each do |card|
        if card.value.count == 1
          value += card.value[0]
        else
          value += card.value[1]
        end
      end
      value
    end

    def min_value
      value = 0
      @cards.each do |card|
        value += card.value[0]
      end
      value
    end

    def highest_value
      if max_value > min_value && max_value <= 21
        max_value
      else
        min_value
      end
    end

  end

  def initialize(name,credits)
    @name = name
    @credits = credits
    @hand = Hand.new(self)
    @active_status = true
  end

  def receive_card(card)
    @hand.cards << card
  end

  def perform_turn(dealer,deck)
    while @active_status

      puts "\n[i] Dealer #{dealer.name} asks: \"What would you like to do?\""
      puts "[?] Please enter the corresponding integer for your choice (1-2, inclusive)"
      @hand.possible_values_inline
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
        puts "\n[i] #{@name} is holding at #{@hand.highest_value}"
        @active_status = false
      else
        puts "\n[i] #{@name} is hitting."
        receive_card(deck.deal_card)
        @hand.description
      end
    end
  end

end