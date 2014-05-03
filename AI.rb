class AI < Person
  attr_accessor :hold_amount

  def initialize(name,credits,hold_amount)
    @name = name
    @credits = credits
    @hold_amount = hold_amount
    @hand = Hand.new(self)
    @active_status = true
  end

  def make_bet
    bet = rand(1..10)
    while bet > @credits
      bet = rand(1..10)
    end
    @recent_bet = bet
    @credits -= @recent_bet
    @recent_bet
  end

  def perform_turn(deck)
    if @hold_amount.is_a?(Array)
      limit = rand(@hold_amount[0]..@hold_amount[@hold_amount.count-1])
    else
      limit = @hold_amount
    end
    while @hand.highest_value < limit
      puts "\n[i] #{@name} is hitting."
      receive_card(deck.deal_card)
      @hand.description
    end

    if @active_status
      puts "\n[i] #{@name} is holding at #{@hand.highest_value}"
    end

  end

end