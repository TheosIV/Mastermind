# frozen_string_literal: true

require_relative 'display'
require_relative 'game_logic'

# player class
class Player
  include Display
  include GameLogic
  attr_accessor :type, :guess
  attr_reader :otimes, :xtimes

  def initialize
    @type = nil
  end

  def player_type
    puts "Type '1' if you want to play as 'Breaker', or '2' to play as 'Setter:"
    answer = gets.chomp.to_i
    until answer.between?(1, 2)
      invalid_input('Game Mode')
      answer = gets.chomp.to_i
    end
    self.type = answer == 1 ? 'Breaker' : 'Setter'
  end

  def set_master_code
    puts "\nChoose a valid master code for the computer to break (e.g. blue green black brown):\n"
    master = gets.chomp.split(' ')
    until master.length == 4 && valid?(master)
      invalid_input('Code')
      master = gets.chomp.split(' ')

    end
    puts "\nYou have set the 'master code' and now it's time for the computer to break the code."
    master
  end

  def guess_master(turns)
    puts "\nTurns #{turns}: Type in four colors to guess master code (e.g. blue green black brown):\n"
    guess = gets.chomp.split(' ')
    until guess.length == 4 && valid?(guess)
      invalid_input('Code')
      guess = gets.chomp.split(' ')

    end
    guess
  end

  def valid?(code)
    code.all? { |color| VALID_COLORS.include?(color) }
  end

  def turns(master)
    turns = 1
    while turns <= 12
      self.guess = guess_master(turns)
      display_guess(guess)
      turn_outcome(master, guess)
      turns += 1
      break if solved?(master, guess)
    end
  end

  def turn_outcome(master, guess)
    compare(master, guess)
    display_clues(otimes, xtimes)
  end

  def game_over(master, guess)
    if solved?(master, guess)
      winner_declaration('Player Broke Code')
    else
      winner_declaration('Computer Broke Code')
    end
    play_again?
  end
end
