class Player
  attr_accessor :name, :marker
  def initialize(marker)
    @name = name_request
    @marker = marker  
  end
  
  def name_request
    print "Enter player name: "
    response = STDIN.gets.chomp
  end
end

class Game
  attr_accessor :board, :player1, :player2, :player_list
  def initialize
    @board = board_generator
    @player1 = Player.new("\u25cb")
    @player2 = Player.new("\u25a0")
    @player_list = [@player1, @player2]
  end
  
  def board_generator
    y = Array.new(6)
    y.each_index do |i|
      y[i] = Array.new(7, '_')
    end
    y
  end
  
  def turn
    puts ' '
    puts "   WELCOME TO CONNECT-FOUR!"
    puts ' '
    print_board
    catch :wins do
    loop do
      @player_list.each do |player|
        puts ' '
        place_pieces(player)
        print_board
        if check_four(player) == true
          puts ' '
          puts "#{player.name.upcase} wins!"
          throw :wins
         end
         if board_full == true
          puts ' '
          puts "It's a TIE!"
          throw :wins     
        end
       end
      end
    end
  end
  
  def choose_column(player)
    counter = 0
    while counter < 1
      print "#{player.name}, select column, 0-6: "
      column = STDIN.gets.chomp.to_i
      counter +=1 if column <=6 and column >= 0
    end
    column
  end
  
  def empty_slot(column)
    @board.each_index do |row|
      return row if @board[row][column] == "_"
    end
       return "Column full"
  end
  
  def place_piece(col, player)
    row = empty_slot(col)
    @board[row][col] = player.marker
  end
    
  def place_pieces(player)
   pair = acceptable_choice(player)
    @board[pair[0]][pair[1]] = player.marker
  end
  
  def acceptable_choice(player)
    counter = 0
    while counter < 1
      col = choose_column(player)
      row = empty_slot(col)
     if row.class == Fixnum
      counter+= 1
      return [row, col]
    else
      puts "Column full"
      end
    end
  end

  def print_board
    puts ''
    @board.reverse.each do |row|
      print  "| #{row.join(' | ')} |"
      puts ' '
    end
     puts ''
     print "  0   1   2   3   4   5   6"
  end
  
  def inspect_row(player)
    runs = []
    @board.each_with_index do |row,i|
      runs[i] = []
        row.each_with_index do |slot, j|
          runs[i] << j if slot == player.marker
        end  
      end
     runs.delete([])
     runs
    end
    
    def inspect_column(player)
     transposed = @board.dup.transpose
      runs = []
      transposed.each_with_index do |row,i|
      runs[i] = []
        row.each_with_index do |slot, j|
          runs[i] << j if slot == player.marker
        end  
      end
     runs.delete([])
     runs
    end
    
    def inspect_rdiagonal(player)
      markers = []
      diagonals = []
      diagonals << Array(2..5).zip(Array(0..3))
      diagonals << Array(1..5).zip(Array(0..4))
      diagonals << Array(0..5).zip(Array(0..5))
      diagonals << Array(0..5).zip(Array(1..6))
      diagonals << Array(0..4).zip(Array(2..6))
      diagonals << Array(0..3).zip(Array(3..6))
      diagonals.each do |diagonal|
         found = []
        diagonal.each do |pair|
          if @board[pair[0]][pair[1]] == player.marker
            found << pair[0]
          end
        end
       markers << found
    end
    markers .delete([])
    markers
   end
   
   def inspect_ldiagonal(player)
      markers = []
      diagonals = []
      diagonals << Array(0..3).zip(Array(3.downto(0)))
      diagonals << Array(0..4).zip(Array(4.downto(0)))
      diagonals << Array(0..5).zip(Array(5.downto(0)))
      diagonals << Array(0..5).zip(Array(6.downto(1)))
      diagonals << Array(1..5).zip(Array(6.downto(2)))
      diagonals << Array(2..5).zip(Array(6.downto(3)))
      diagonals.each do |diagonal|
         found = []
        diagonal.each do |pair|
          if @board[pair[0]][pair[1]] == player.marker
            found << pair[0]
          end
        end
       markers << found
    end
    markers .delete([])
    markers
   end
  
  def split_consecutive(arrays)
    consecutive = []
    arrays.each do |row|
      consec =  [[row[0]]]
      i = 0
      row.each_cons(2) do |j, k|
        k - j == 1 ? consec[i] << k : consec [i+=1] = [k]
      end
      consecutive << consec
    end
    consecutive.flatten(1)
  end
    
  def longest_streak(streaks)
    if streaks[0].nil?
      0
    else
      largest = streaks[0].size
      for i in 1...streaks.size
        largest = streaks[i].size if streaks[i].size > largest
      end
      largest
    end
  end
  
  def check_four(player)
    checked = []
    checked << longest_streak(split_consecutive(inspect_row(player)))
    checked << longest_streak(split_consecutive(inspect_column(player)))
    checked << longest_streak(split_consecutive(inspect_rdiagonal(player)))
    checked << longest_streak(split_consecutive(inspect_ldiagonal(player)))
    checked.each {|num| return true if num >= 4}
    return false
  end
  
  def board_full
    @board.each do |row|
      return false if row.include? "_"
    end
      return true
  end
   
end

z = Game.new
z.turn