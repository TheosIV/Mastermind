# frozen_string_literal: true

require_relative 'colors'

# display module
module Display
  def instructions
    <<~HEREDOC
      #{'Welcome to Mastermind!'.underline.italic.bold}

      This is a 1-player game against the computer.
      You can choose to be the code #{'BREAKER'.bold.underline} or the code #{'SETTER'.bold.underline}.

      There are six different color combinations:

      #{colored_guess('blue')} #{colored_guess('cyan')} #{colored_guess('green')} #{colored_guess('purple')} #{colored_guess('white')} #{colored_guess('yellow')}

      The code setter will choose four to create a 'master code'. For example:

      #{colored_guess('green')} #{colored_guess('yellow')} #{colored_guess('green')} #{colored_guess('purple')}

      As you can see, there can be #{'more than one'.red} of the same color.
      In order to win, the code breaker needs to guess the 'master code' in 12 or less turns.

      #{'Clues: '.bold.underline}
      After each guess, there will be up to four clues to help crack the code.

      \e[91m\u25CF\e[0m This clue means you have 1 correct color in the correct position.
      \e[37m\u25CB\e[0m This clue means you have 1 correct color, but in the wrong position.

      #{'Clues Example: '.underline.bold}

      #{colored_guess('green')} #{colored_guess('purple')} #{colored_guess('yellow')} #{colored_guess('purple')} clues: #{clues('o')} #{clues('o')} #{clues('x')}

      The guess had 2 correct colors in the correct position and 1 correct color in a wrong position.

      #{'Game Started!'.underline.bold}

    HEREDOC
  end

  def clues(clue = 'x')
    {
      'o' => "\e[91m\u25CF\e[0m ",
      'x' => "\e[37m\u25CB\e[0m "
    }[clue]
  end

  def display_clues(otimes, xtimes)
    print ' clues: '
    otimes.times { print clues('o') }
    xtimes.times { print clues }
    puts ''
  end

  def colored_guess(color)
    {
      'blue' => '    Blue    '.bg_blue,
      'cyan' => '    Cyan    '.bg_cyan,
      'green' => '   Green    '.bg_green,
      'purple' => '   Purple   '.bg_magenta,
      'white' => '   White    '.white.bg_gray,
      'yellow' => '   Yellow   '.bg_brown
    }[color]
  end

  def display_guess(guess)
    print "\n"
    guess.each { |color| print "#{colored_guess(color)} " }
  end

  def winner_declaration(type)
    case type
    when 'Player Broke Code'
      puts "\nYou broke the code! Congratulations, you win!\n".green

    when 'Computer Broke Code'
      puts "\nGame over. The computer broke your code thus, you lose!\n".red

    when 'Computer Failed'
      puts "\nThe computer failed to break the code thus, you win!\n".green

    end
  end

  def invalid_input(type)
    case type
    when 'Game Mode'
      puts "\nPlease type '1' or '2' and nothing else!".red
    when 'Code'
      puts "\nPlease enter 4 valid colors!".red
    when 'Play Again'
      puts "\nPlease type 'Y' or 'N' and nothing else!".red
    end
  end
end
