# Run user's text interface

require './game.rb'
require './card_deck.rb'

class UserInterface
  def initialize
    puts 'Добро пожаловать в игру Black Jack!'
    @game = Game.new
  end

  def take_name
    puts 'Укажите совое имя: '
    player_name = gets.chomp
    @game.create_players(player_name)
  end

  def first
    @game.first_step
    puts "Вам раздали карты, на руках #{@game.players[0].hand.cards.map(&:name)}"
    puts "У вас #{@game.players[0].hand.cards_count}"
    puts 'У дилера на руках 2 карты [*] [*]'
    second
  end

  def second
    puts 'Ваш ход: 1 - Пропустить ход  2 - Взять карту  3 - Открыть карты'
    choice = gets.chomp
    if choice == '1'
      fourth
    elsif choice == '2'
      third
    elsif choice == '3'
      fifth
    end
  end

  def fourth
    @game.dealers_step
    if @game.players[1].hand.cards.count == 3
      puts 'Дилер взял карту, на руках 3 карты [*] [*] [*]'
      @game.valid_cards ? fifth : second
    else
      puts 'Дилер пропустил ход'
      second
    end
  end

  # rubocop: disable Metrics/AbcSize

  def third
    if @game.players[0].hand.cards.count == 3
      puts 'У вас максимальное количество карт!'
      second
    else
      @game.one_card
      puts "Вы взяли карту, на руках #{@game.players[0].hand.cards.map(&:name)}"
      puts "У вас #{@game.players[0].hand.cards_count} очков"
      @game.dealers_step
      fourth
    end
  end

  def fifth
    @game.end_game
    puts "У #{@game.players[0].name} на руках #{@game.players[0].hand.cards.map(&:name)}"
    puts "Очков #{@game.players[0].hand.score}"
    puts "У Дилера на руках #{@game.players[1].hand.cards.map(&:name)}"
    puts "Очков #{@game.players[1].hand.score}"
    @game.valid ? valid_message : congratulations_message
  end

  def congratulations_message
    if @game.winner == @game.players[1]
      puts "Победил Дилер, у него #{@game.players[1].money}$"
    elsif @game.winner == @game.players[0]
      puts "Вы победили, у вас #{@game.players[0].money}$"
    elsif @game.winner == 2
    puts 'Ничья, все остались при своих деньгах.'
    puts "У #{@game.players[0].name} #{@game.players[0].money}$"
    puts "У #{@game.players[1].name} #{@game.players[1].money}$"
    end
    again
  end

  def valid_message
    if @game.winner == @game.players[1]
    puts "Победил Дилер, теперь у него #{@game.players[1].money}$"
    elsif @game.winner == @game.players[0]
    puts "Вы победили, теперь у вас #{@game.players[0].money}$"
    elsif @game.winner == 1
    puts 'Вы оба проиграли!'
    end
    again
  end

  # rubocop: enable Metrics/AbcSize

  def again
    @game.post_game
    puts '1: Сыграть еще раз?  2:  Выйти'
    choice = gets.chomp
    choice == '1' ? first : exit
  end
end

ui = UserInterface.new
ui.take_name
ui.first
