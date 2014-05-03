class Deck

  class Card
    attr_accessor :symbol
    attr_accessor :value
    attr_accessor :suit

    def initialize(suit,symbol,value)
      @symbol = symbol
      @suit = suit
      @value = value
    end

    def description
      "   - #{@value}: #{@symbol} of #{@suit}"
    end
  end

  def initialize(deck_count)
    reset(deck_count)
  end

  def reset(deck_count)
    @cards = []

    suits = ['Hearts','Clubs','Spades','Diamonds']
    combinations = [
        {:symbol => 'Ace', :value => [1,11]},
        {:symbol => '2', :value => [2]},
        {:symbol => '3', :value => [3]},
        {:symbol => '4', :value => [4]},
        {:symbol => '5', :value => [5]},
        {:symbol => '6', :value => [6]},
        {:symbol => '7', :value => [7]},
        {:symbol => '8', :value => [8]},
        {:symbol => '9', :value => [9]},
        {:symbol => '10', :value => [10]},
        {:symbol => 'Jack', :value => [10]},
        {:symbol => 'Queen', :value => [10]},
        {:symbol => 'King', :value => [10]}
    ]

    deck_count.times do
      suits.each do |suit|
        combinations.each do |combination|
          @cards << Card.new(suit,combination[:symbol],combination[:value])
        end
      end
    end

    shuffle_deck
  end

  def shuffle_deck
    @cards.shuffle!
  end

  def deal_card
    @cards.pop
  end

end