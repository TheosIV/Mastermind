# frozen_string_literal: true

require_relative 'game'

# game logic module
module GameLogic
  VALID_COLORS = %w[blue cyan green purple white yellow].freeze

  def exact_positions(master, guess)
    exact = 0
    master.each_with_index do |item, index|
      next unless item == guess[index]

      exact += 1
      master[index] = 'o'
      guess[index] = 'o'
    end
    exact
  end

  def wrong_positions(master, guess)
    wrong = 0
    master.each_index do |index|
      next unless guess[index] != 'o' && master.include?(guess[index])

      wrong += 1
      replace = master.find_index(guess[index])
      master[replace] = 'x'
      guess[index] = 'x'
    end
    wrong
  end

  def compare(master, guess)
    master_clone = master.clone
    guess_clone = guess.clone
    @otimes = exact_positions(master_clone, guess_clone)
    @xtimes = wrong_positions(master_clone, guess_clone)
  end

  def solved?(master, guess)
    guess == master
  end

  def play_again?
    puts "\nDo you want to play again? Press 'Y' for yes or 'N' for no:"
    answer = gets.chomp.downcase
    until %w[y n].include?(answer)
      invalid_input('Play Again')
      answer = gets.chomp.downcase

    end
    if answer == 'y'
      Game.new.play
    else
      puts "\nSee you soon!"
    end
  end
end
