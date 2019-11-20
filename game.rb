require './users.rb'
require './card_deck.rb'
require './hand.rb'

class Game
  attr_reader :user, :bank, :card_deck, :decks, :winner, :computer

  def initialize
    @user = user
    @computer = computer
    @bank = 0
    @winner = 0
  end

  def create_players(player_name)
    @user = Player.new(player_name)
    @user.hand = Hand.new
    @computer = Dealer.new
    @computer.hand = Hand.new
  end

  def first_step
    @decks = Cards.new
    deal_cards(@user, 2)
    deal_cards(@computer, 2)
    take_bit
  end

  def valid_cards
    @user.hand.cards.count && @computer.hand.cards.count == 3
  end

  def take_bit
    @user.money -= 10
    @computer.money -= 10
    first_bit = 20
    @bank += first_bit
  end

  def one_card
    deal_cards(@user, 1)
  end

  def dealers_step
    @computer.hand.cards_count
    if @computer.hand.cards.count < 3 && @computer.hand.score <= 17
      deal_cards(@computer, 1)
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
    if @user.hand.score > 21 && @computer.hand.score < 22
      @winner = @computer
    elsif  @computer.hand.score > 21 && @user.hand.score < 22
      @winner = @user
    elsif  @user.hand.score > 21 && @computer.hand.score > 21
      @winner = 'losers'
    end
  end

  # rubocop: enable Metrics/PerceivedComplexity
  # rubocop: enable Metrics/CyclomaticComplexity
  def congratulations
    if @user.hand.score <= 21 && @user.hand.score > @computer.hand.score
      @winner = @user
    elsif @computer.hand.score <= 21 && @computer.hand.score > @user.hand.score
      @winner = @computer
    elsif @user.hand.score == @computer.hand.score
      @winner = 'draw'
    end
  end

  # rubocop: enable Metrics/AbcSize

  def calculation
    if @winner == @user
    @user.money += @bank
    elsif @winner == @computer
    @computer.money += @bank
    elsif @winner == 2
    @user.money += (@bank / 2)
    @computer.money += (@bank / 2)
    end
  end

  def end_game
    @user.hand.cards_count
    @computer.hand.cards_count
    valid
    congratulations
    calculation
  end

  def post_game
    @user.hand = Hand.new
    @computer.hand = Hand.new
    @bank = 0
  end
end
