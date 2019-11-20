# Create new card deck

class Cards
  attr_reader :card_deck, :cards_parity, :name

  def initialize
    @card_deck = []
    new_cards
  end

  def new_cards
    card_generator = [(2..10).to_a, Card::PICTURES].flatten!
    card_generator.each do |card|
      Card::SUITS.each do |suit|
        @card_deck << Card.new(suit, card)
      end
    end
  end
end

class Card
  attr_reader :name, :suit
  attr_accessor :score

  SUITS = %w[♠ ♥ ♣ ♦].freeze
  PICTURES = %i[J Q K A].freeze
  SCORES = { J: 10, Q: 10, K: 10, A: 11 }.freeze

  def initialize(suit, name)
    @suit = suit
    @name = name
  end

  def price
    @score = (2..10).include?(@name) ? @name : SCORES[@name]
  end

  def face
    @suit.to_s + ' ' + @name.to_s
  end
end
