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

end