# Create new card deck

class Cards
  attr_reader :card_deck, :cards_parity, :on_hand, :summary

  def initialize
    @card_deck = []
    card_generator = [(2..10).to_a, %w[J Q K A]].flatten!
    card_generator.each do |cards|
      @card_deck << '♥ ' + cards.to_s
      @card_deck << '♦ ' + cards.to_s
      @card_deck << '♣ ' + cards.to_s
      @card_deck << '♠ ' + cards.to_s
    end
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
end
