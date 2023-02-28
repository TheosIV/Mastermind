module Display
  VALID_COLORS = ['blue', 'brown', 'black', 'green', 'magenta', 'cyan']

  def colored_code(color)
    {
      'blue' => "\e[44m    blue    \e[0m ",
      'brown' => "\e[43m   brown    \e[0m ",
      'black' => "\e[40m   black    \e[0m ",
      'green' => "\e[42m    green   \e[0m ",
      'magenta' => "\e[45m  magenta   \e[0m ",
      'cyan' => "\e[46m    cyan    \e[0m "
    }[color]
  end

  def clues(clue)
    {
      '*' => "\e[91m\u25CF\e[0m ",
      '?' => "\e[37m\u25CB\e[0m "
    }[clue]
  end

  def display_clues(exact, same)
    print ' clues: '
    exact.times {print clues('*')}
    same.times {print clues('?')}
    puts ''
  end

  def display_guess(guess)
    print "\n"
    guess.each {|color| print colored_code(color)}
  end

end

class Computer
  include Display
  attr_reader :type

  @@index = 0
  @@guess_array = []
  def initialize
      @type = nil
  end

  def breaker_setter?(type)
      @type = type
  end

  def set_code
      code = VALID_COLORS.sample(4)
  end

  def guess(guess_array)
      color = VALID_COLORS[@@index]
      (4 - guess_array.length).times {guess_array << color}
      @@index += 1
      guess_array
  end
end

class Player
  include Display
  attr_reader :type

  def initialize
      @type = nil
  end

  def breaker_setter? 
      type = gets.chomp.to_i 
      type = gets.chomp.to_i until type.between?(1, 2)
      type.to_i == 1 ? @type = 'Breaker' : @type = 'Setter'
  end

  def set_code
      puts "Set code:"
  end

  def guess
      guess = gets.chomp
      guess
  end

  def valid_guess(guess)
      VALID_COLORS.include?(guess)
  end
end

class Mastermind
  include Display
  attr_reader :player, :computer
  attr_accessor :turns
  def initialize
      @player = Player.new
      @computer = Computer.new
      @turns = 0
      play
  end

  def asign_player_role
      puts "Type '1' if you want to play as 'Breaker', or '2' to play as 'Setter:"
      player.breaker_setter?
  end

  def asign_computer_role
      computer.breaker_setter?(player.type == 'Breaker' ? 'Setter' : 'Breaker')
  end

  def fff
      player.type == 'Breaker' ? player_is_breaker : player_is_setter
  end

  def player_guessing
    guess = []
    puts "guess: "
    until guess.length == 4 && guess.all? {|color| player.valid_guess(color)}
        guess = gets.chomp
        guess = guess.split(' ')
    end
    guess
  end

  def player_is_breaker
      master = computer.set_code
      until turns == 12 do
        symbol_master = master.dup
        guess = player_guessing
        symbol_guess = guess.dup
        exact = exact(symbol_master, symbol_guess)
        same = right(symbol_master, symbol_guess)
        display_guess(guess)
        display_clues(exact, same)
        break if winner?('Player', master, guess)
      end
  end

  def player_setting
    code = []
      puts "Choose code:"
      until code.length == 4 && code.all? {|color| player.valid_guess(color)}
          code = gets.chomp
          code = code.split(' ')
      end
      code
  end

  def exact(master, guess)
    exact = 0
    master.each_with_index do |item, index|
      next unless item == guess[index]

      exact += 1
      guess[index] = '*'
      master[index] = '*'
    end
    exact
  end

  def right(master, guess)
    same = 0
    master.each_index do |index|
      next unless guess[index] != '*' && master.include?(guess[index])

      same += 1
      remove = master.find_index(guess[index])
      master[remove] = '?'
      guess[index] = '?'
    end
    same
  end

  def winner?(breaker, code, guess)
    if guess == code
      puts "#{breaker} Wins!"
      true
    end
  end

  

  def guessing_colors(guess, master)
      guess = computer.guess(guess)
      if !master.include?(guess[3])
        guess.pop(guess.count(guess[3]))
      else
        guess.pop(guess.count(guess[3]) - master.count(guess[3]))
      end
      guess
  end

  def right_order(master, guess)
        wrong = nil
        guess.each_with_index do |item, index|
          next unless item != master[index]
          
          if wrong == nil
            wrong = index
          else
            guess[index] = guess[wrong]
            guess[wrong] = item
          end
        end
        guess
  end

  def player_is_setter
    master = player_setting
    guess = []

    until turns == 12
      symbol_master = master.dup
      if guess.length < 4
        guess = computer.guess(guess)
        symbol_guess = guess.dup
        exact = exact(symbol_master, symbol_guess)
        same = right(symbol_master, symbol_guess)
        display_guess(guess)
        display_clues(exact, same)
        if !master.include?(guess[3])
          guess.pop(guess.count(guess[3]))
        else
          guess.pop(guess.count(guess[3]) - master.count(guess[3]))
        end
      else
        guess = right_order(master, guess)
        symbol_guess = guess.dup
        exact = exact(symbol_master, symbol_guess)
        same = right(symbol_master, symbol_guess)
        guess_display(guess)
        display_clues(exact, same)
        break if winner?('Computer', master, guess)
      end
      @turns += 1
    end
  end

  def play
      asign_player_role
      asign_computer_role
      fff
  end

end

g = Mastermind.new