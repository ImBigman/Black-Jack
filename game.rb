require './users.rb'
require './card_deck.rb'
require './hand.rb'

class Game
  attr_reader :players, :bank, :card_deck, :decks, :winner

  def initialize
    @players = []
    @bank = 0
    @winner = 0
  end

  def create_players(player_name)
    @players.push(Player.new(player_name), Dealer.new)
    @players[0].hand = Hand.new
    @players[1].hand = Hand.new
  end

  def first_step
    @decks = Cards.new
    deal_cards(@players[0], 2)
    deal_cards(@players[1], 2)
    take_bit
  end

  def valid_cards
    @players[0].hand.cards.count && @players[1].hand.cards.count == 3
  end

  def take_bit
    @players[0].money -= 10
    @players[1].money -= 10
    first_bit = 20
    @bank += first_bit
  end

  def one_card
    deal_cards(@players[0], 1)
  end

  def dealers_step
    @players[1].hand.cards_count
    if @players[1].hand.cards.count < 3 && @players[1].hand.score <= 17
      deal_cards(@players[1], 1)
    else
      valid_cards
    end
  end
  # rubocop: disable Metrics/AbcSize

  def deal_cards(player, quantity)
    @player = player
    @player.hand.cards << decks.card_deck.sample(quantity)
    @player.hand.cards.flatten!
    decks.card_deck.delete_if { |cards| @player.hand.cards.include?(cards) }
  end
  # rubocop: disable Metrics/CyclomaticComplexity
  # rubocop: disable Metrics/PerceivedComplexity

  def valid
    if @players[0].hand.score > 21 && @players[1].hand.score < 22
      @winner = @players[1]
    elsif  @players[1].hand.score > 21 && @players[0].hand.score < 22
      @winner = @players[0]
    elsif  @players[0].hand.score > 21 && @players[1].hand.score > 21
      @winner = 1
    end
  end

  # rubocop: enable Metrics/PerceivedComplexity
  # rubocop: enable Metrics/CyclomaticComplexity
  def congratulations
    if @players[0].hand.score <= 21 && @players[0].hand.score > @players[1].hand.score
      @winner = @players[0]
    elsif @players[1].hand.score <= 21 && @players[1].hand.score > @players[0].hand.score
      @winner = @players[1]
    elsif @players[0].hand.score == @players[1].hand.score
      @winner = 2
    end
  end

  # rubocop: enable Metrics/AbcSize

  def calculation
    if @winner == @players[0]
    @players[0].money += @bank
    elsif @winner == @players[1]
    @players[1].money += @bank
    elsif @winner == 2
    @players[0].money += (@bank / 2)
    @players[1].money += (@bank / 2)
    end
  end

  def end_game
    @players[0].hand.cards_count
    @players[1].hand.cards_count
    valid
    congratulations
    calculation
  end

  def post_game
    @players.each do |player|
      player.hand = Hand.new
    end
    @bank = 0
  end
end
