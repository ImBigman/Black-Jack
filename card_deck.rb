# Create new card deck

class Cards
  attr_reader :card_deck, :cards_parity

  # rubocop: disable Metrics/AbcSize
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

  # rubocop: enable Metrics/AbcSize
end
