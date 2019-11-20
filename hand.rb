# Players cards on hand

class Hand
  attr_accessor :score, :cards

  def initialize
    @cards = []
    @score = 0
  end

  def cards_count
    summary ||= []
    @cards.each { |card| summary << card.price }
    summary[-1] = 1 if summary.last == 11 && summary.count(11) == 2
    summary[-1] = 1 if summary.last == 11 && summary[0..-2].sum > 10
    @score = summary.sum
  end
end
