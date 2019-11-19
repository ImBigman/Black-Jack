# Players cards on hand

class Hand
  attr_accessor :score, :cards

  def initialize
    @cards = []
    @score = 0
  end

  def cards_price
    @cards_parity = {}
    card_deck_price = [(1..10).to_a, %w[J Q K A]].flatten!
    card_deck_price.each.with_index(1) { |cards, index| @cards_parity[:"#{cards}".to_sym] = index }
    @cards_parity.each do |key, _|
      @cards_parity[key] = 10 if %i[J Q K].include?(key)
      @cards_parity[key] = 11 if %i[A].include?(key)
    end
  end

  # rubocop: disable Metrics/AbcSize
  def cards_count
    cards_price
    summary ||= []
    cards = @cards.map { |elem| elem[2..-1].to_sym }
    cards.each { |card| summary << @cards_parity[card] }
    summary[-1] = 1 if summary.last == 11 && summary.count(11) == 2
    summary[-1] = 1 if summary.last == 11 && summary[0..-2].sum >= 10
    @score = summary.sum
  end
  # rubocop: enable Metrics/AbcSize
end
