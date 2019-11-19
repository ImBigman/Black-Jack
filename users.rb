# Create player with start money

class Player
  attr_reader :name
  attr_accessor :money, :hand

  def initialize(name)
    @name = name
    @money = 100
    @hand = 0
  end
end

class Dealer < Player
  def initialize(name = 'Dealer')
    super
  end
end
