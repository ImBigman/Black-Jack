# Create player with start money

class Player
  attr_reader :name, :start_money
  attr_accessor :money, :on_hand_score, :on_hand

  def initialize(name)
    @name = name
    @money = 100
    @on_hand ||= []
  end
end

class Dealer < Player
  def initialize(name = 'Dealer')
    super
  end
end
