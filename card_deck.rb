# Create new card deck

class Cards
  attr_reader :card_deck, :cards_parity, :name

  # rubocop: disable Metrics/AbcSize
  def initialize
    @card_deck = []
    card_generator = [(2..10).to_a, %w[J Q K A]].flatten!
    card_generator.each do |cards|
      @card_deck << Card.new('♥ ' + cards.to_s, 0)
      @card_deck << Card.new('♦ ' + cards.to_s, 0)
      @card_deck << Card.new('♣ ' + cards.to_s, 0)
      @card_deck << Card.new('♠ ' + cards.to_s, 0)
      price_to_cards
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

  def price_to_cards
    cards_price
    @card_deck.each { |card| card.score = @cards_parity[card.name[2..-1].to_sym] }
  end
end

# rubocop: enable Metrics/AbcSize

class Card
  attr_reader :name
  attr_accessor :score

  def initialize(name, score)
    @name = name
    @score = score
  end
end
