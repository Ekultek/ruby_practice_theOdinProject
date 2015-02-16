# TIC TAC TOE
# The Odin Project, Dawn Pattison 1/30
# Player Class: squares track spaces player has marked
class Player
  attr_accessor :name, :mark, :squares
  def initialize(name, mark)
    @name = name
    @mark = mark
    @squares = []
  end
end
# Board class, includes all game functions
class Board
  attr_accessor :board, :player_1, :player_2, :player_list, :valid, :stop
  def initialize
    @board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    @player_1 = Player.new('Player 1', 'X')
    @player_2 = Player.new('Player 2', 'O')
    @player_list = [@player_1, @player_2]
    @valid = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @stop = false
  end
  
  def turn
    puts ''
    puts 'Welcome to TIC-TAC-TOE'
    puts ''
    sleep(0.5)
    print_board
    counter = 0
    catch :finish do
      loop do
        player_list.each do |human|
          square = choose(human)
          draw(square, human)
          print_board
          check(human)
          counter += 1
          final(human, counter)
        end
      end
    end
  end
  
  def choose(human)
    tic = 0
    puts ''
    sleep(1)
    puts "#{ human.name }, your move."
    while tic < 1
      print "Enter the square where you'd like to place an #{ human.mark }: "
      pick = gets.chomp.to_i
      if @valid.include? pick
        tic += 1
        return pick
      else
        puts ''
        puts 'Invalid entry'
      end
    end
  end
  
  def draw(square, human)
    @board.each_with_index do  |line, i|
      line.each_with_index do |char, j|
        if char == square
          @board[i][j] = human.mark
          human.squares << square
          @valid.delete(square)
        end
      end
    end
  end
  
  def print_board
    puts ''
    @board.each do |line|
      puts line.join('   ')
    end
  end
  
  def check(human)
    tests = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]] 
    tests.each do |test|
      @stop = true if (test - human.squares).empty?
    end
  end
  
  def final(human, counter)
    if @stop == true
      sleep(1)
      puts ''
      puts "#{human.name} wins!"
      throw :finish
    end
    if counter == 9
      sleep(1)
      puts ''
      puts 'TIE!  Cat wins!'
      throw :finish
    end
  end
  
end

# z = Board.new
# z.turn
