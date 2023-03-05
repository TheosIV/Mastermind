# frozen_string_literal: true

require_relative 'display'
require_relative 'game_logic'
require_relative 'game'

# computer class
class Computer
  include Display
  include GameLogic
  attr_accessor :type, :index, :guess
  attr_reader :otimes, :xtimes

  def initialize
    @type = nil
    @index = 0
  end

  def computer_type(player_type)
    self.type = player_type == 'Breaker' ? 'Setter' : 'Breaker'
  end

  def set_master_code
    master = VALID_COLORS.sample(4)
    puts "\nThe computer has set the 'master code' and now it's time for you to break the code."
    master
  end

  def guess_master(guess)
    color = VALID_COLORS[index]
    (4 - guess.length).times { guess << color }
    self.index += 1
    guess
  end

  def remove_colors(master, guess)
    master.include?(guess[3]) ? guess.pop(guess.count(guess[3]) - master.count(guess[3])) : guess.pop(guess.count(guess[3]))
    guess
  end

  def colors_order(master, guess)
    wrong = nil
    guess.each_with_index do |item, index|
      next unless item != master[index]

      if wrong.nil?
        wrong = index
      else
        guess[index] = guess[wrong]
        guess[wrong] = item
      end
    end
    guess
  end

  def turns(master)
    turns = 1
    self.guess = []
    while turns <= 12
      sleep 1
      self.guess = guess_master(guess)
      display_guess(guess)
      turn_outcome(master, guess)
      break if solved?(master, guess)
      self.guess = remove_colors(master, guess)
      colors_order(master, guess)
      turns += 1
    end
  end

  def turn_outcome(master, guess)
    compare(master, guess)
    display_clues(otimes, xtimes)
  end

  def game_over(master, guess)
    if solved?(master, guess)
      winner_declaration('Computer Broke Code')
    else
      winner_declaration('Computer Failed')
    end
    play_again?
  end
end
