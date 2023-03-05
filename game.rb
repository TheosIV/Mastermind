# frozen_string_literal: true

require_relative 'game_logic'
require_relative 'player'
require_relative 'display'
require_relative 'computer'

# game class
class Game
  include Display

  attr_reader :player, :computer
  attr_accessor :turns

  def initialize
    @player = Player.new
    @computer = Computer.new
    @turns = nil
  end

  def code_breaker
    master = computer.set_master_code
    player.turns(master)
    player.game_over(master, player.guess)
  end

  def code_maker
    master = player.set_master_code
    computer.turns(master)
    computer.game_over(master, computer.guess)
  end

  def game_mode
    player.type == 'Breaker' ? code_breaker : code_maker
  end

  def play
    puts instructions
    player.player_type
    computer.computer_type(player.type)
    game_mode
  end
end
