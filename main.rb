require './users.rb'
require './card_deck.rb'

# rubocop: disable Metrics/ClassLength
class Game
  attr_reader :name, :players
  attr_reader :bank, :card_deck, :decks

  def initialize
    puts 'Добро пожаловать в игру Black Jack!'
    @players = []
    @bank = 0
  end

  def pre_game_menu
    puts '1:  Начать игру  2:  Выйти '
    choice = gets.chomp
    choice == '1' ? start_game : exit
  end

  def start_game
    puts 'Укажите совое имя: '
    player_name = gets.chomp
    @players.push(Player.new(player_name), Dealer.new)
  end

  def take_bit
    @players[0].money -= 10
    @players[1].money -= 10
    first_bit = 20
    @bank += first_bit
  end

  def one_card
    if @players[0].on_hand.count == 3
      puts 'У вас максимальное количество карт!'
      second_step
    elsif deal_cards(@players[0], 1)
      puts "Вы взяли карту, на руках #{@players[0].on_hand}"
      puts "У вас #{count_cards(@players[0])} очков"
      second_step
    end
  end

  def dealers_step
    second_step
    if @players[1].on_hand.count < 3 && count_cards(@players[1]) <= 17
      deal_cards(@players[1], 1)
      puts 'Диллер взял карту, на руках 3 карты [*] [*] [*]'
    else
      puts 'Диллер пропустил ход'
    end
    post_game
  end

  # rubocop: disable Metrics/AbcSize
  def end_game
    puts "У #{@players[0].name} на руках #{@players[0].on_hand}"
    p count_cards(@players[0])
    puts "У Диллера на руках #{@players[1].on_hand}"
    p count_cards(@players[1])
    valid
    congratulations
  end

  def second_step
    end_game if @players[0].on_hand.count == 3 && @players[1].on_hand.count == 3
    puts 'Вы можете: 1 - Пропустить ход  2 - Взять карту 3 - Открыть карты'
    choice = gets.chomp
    if choice == '1'
      dealers_step
    elsif choice == '2'
      one_card
    else
      end_game
    end
  end

  def first_step
    @decks = Cards.new
    @decks.cards_price
    deal_cards(@players[0], 2)
    puts "Вам раздали карты, на руках #{@players[0].on_hand} "
    puts "У вас #{count_cards(@players[0])} очков"
    deal_cards(@players[1], 2)
    puts 'У дилера на руках 2 карты [*] [*]'
    take_bit
    second_step
  end

  def congratulations
    if @players[0].on_hand_score <= 21 && @players[0].on_hand_score > @players[1].on_hand_score
      puts "Вы победили, на руках #{@players[0].money += @bank}$"
    elsif @players[1].on_hand_score <= 21 && @players[1].on_hand_score > @players[0].on_hand_score
      puts "Победил диллер, у него на руках #{@players[1].money += @bank}$"
    elsif @players[0].on_hand_score == @players[1].on_hand_score
      puts 'Ничья, все остались при своих деньгах.'
      puts "#{@players[0].name}, на руках #{@players[0].money += (@bank / 2)}$"
      puts "#{@players[1].name}, на руках #{@players[1].money += (@bank / 2)}$"
    end
  end

  def valid
    if @players[0].on_hand_score > 21
      puts "Победил диллер, у него #{@players[1].money += @bank}$"
      post_game
    elsif  @players[1].on_hand_score > 21
      puts "Вы победили, у вас #{@players[0].money += @bank}$"
      post_game
    elsif  @players[0].on_hand_score > 21 && @players[1].on_hand_score > 21
      puts 'Вы оба проиграли!'
      post_game
    end
  end
  # rubocop: enable Metrics/AbcSize

  def deal_cards(player, quantity)
    @player = player
    @player.on_hand << decks.card_deck.sample(quantity)
    @player.on_hand.flatten!
    decks.card_deck.delete_if { |cards| @player.on_hand.include?(cards) }
  end

  def count_cards(player)
    summary ||= []
    @player = player
    cards = player.on_hand.map { |elem| elem[2..-1].to_sym }
    cards.each { |card| summary << decks.cards_parity[card] }
    summary[-1] = 1 if summary.last == 11 && summary.count(11) == 2
    player.on_hand_score = summary.sum
  end

  def post_game
    @players.each do |player|
      player.on_hand = []
      player.on_hand_score = 0
    end
    @bank = 0
    puts '1: Сыграть еще раз?  2:  Выйти'
    choice = gets.chomp
    choice == '1' ? first_step : exit
  end
end
# rubocop: enable Metrics/ClassLength

def menu
  @game = Game.new
end
menu
@game.pre_game_menu
@game.first_step
@game.post_game
