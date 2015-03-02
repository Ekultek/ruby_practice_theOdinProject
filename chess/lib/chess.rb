require 'yaml'
# board class, keeps track of game pieces
class Game
  attr_accessor :board, :players
  def initialize
    $board = board_generator
    @players = ["white", "black"]
    @current_player_index = 0
    @prev_coord = [0, 0]
    @prev_delta_y = nil
  end
  def next_player_index 
    1 - @current_player_index 
  end
  def switch_player
    @current_player_index = next_player_index
  end
  #game needs to make sure input, and output are on board
  def board_generator
    y = Array.new(8)
    y.each_index {|i|  y[i] = Array.new(8)}
  end
  # places all pieces on board
  def setup_board
    place_pawns
    place_bishops
    place_rooks
    place_knights
    place_queens
    place_kings
  end
 
  def self.welcome
    puts ''
    print 'Welcome to CHESS!'.center(27)
    puts ''
    loop do
      puts ''
      print "Do you want to start a (N)ew game, open a (S)aved game, or (E)xit?"
      response = STDIN.gets.chomp.upcase
      if response == 'S'
        if File.exist? ('saved_game.rb')
          LoadGame.new
        else
          puts 'There are no games saved!'
          sleep (0.3)
          puts 'Starting new game...'
          sleep(0.3)
          NewGame.new
        end
      elsif response == 'N'
        NewGame.new
      elsif response == 'E'
        print 'Thank you for playing!'
        return
      else
        puts "I don't understand!"
      end
    end 
   end
  # Main game loop
  def play
    catch :finish do
      loop do
        player = @players[@current_player_index]
        game_over = checkmate(player)
        if game_over
          sleep(1)
          puts "CHECKMATE"
          print_board($board)
          throw :finish
        end
        counter = 0
        while counter < 1
          sleep(0.5)
          print_board($board)
          print "#{player.capitalize}, your move."
          start = move_from
          piece = piece_in_play(start)
          stop = move_to(piece)
          if permissible(start, stop, piece, player)
            move_player(start, stop, piece)
            counter +=1
          end
        end  
        switch_player
      end
    end
  end
  # Prints board nicely
  def print_board(board)
    puts ' '
    game_board = board.dup.transpose.reverse
    game_board.each_with_index do |row, i|
      row.each_index do |j|
        if game_board[i][j].nil?
          game_board[i][j] = '__'
        else
          game_board[i][j] = game_board[i][j].symbol 
        end
      end
    end
    game_board.each_with_index do |row, i|
        puts "#{8-i}| #{row.join(' ')}"
     end
    puts ''
    puts '    a  b  c  d  e  f  g  h'
    puts ''
  end  
  # Places pawns on board, instantiating them
  def place_pawns
    $board.each_index do |x|
    $board[x][1] = Pawn.new('white')
    $board[x][6] = Pawn.new('black')
    end
  end
  # Places four rooks on board
  def place_rooks
    $board[0][0] = Rook.new('white')
		$board[7][0] = Rook.new('white')
		$board[0][7] = Rook.new('black')
		$board[7][7] = Rook.new('black')
  end
    # Places four knights on board
  def place_knights
    $board[1][0] = Knight.new('white')
		$board[6][0] = Knight.new('white')
		$board[1][7] = Knight.new('black')
		$board[6][7] = Knight.new('black')
  end
    # Places 4 bishops on board
  def place_bishops
    $board[2][0] = Bishop.new('white')
		$board[5][0] = Bishop.new('white')
		$board[2][7] = Bishop.new('black')
		$board[5][7] = Bishop.new('black')
  end
   # Places 2 queens
  def place_queens
    $board[3][0] = Queen.new('white')
		$board[3][7] = Queen.new('black')
  end
    # Places 2 kings
  def place_kings
    $board[4][0] = King.new('white')
		$board[4][7] = King.new('black')
  end
    # Prompts player for starting piece 
  def move_from
    puts ''
    cols = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    rows = [1, 2, 3, 4, 5, 6, 7, 8]
    counter = 0; x = ''; y = ''
    until counter == 1
      print "Enter starting coordinates: " 
      coordinate = STDIN.gets.chomp
      if coordinate == 'save' or coordinate == 'Save' or coordinate == 'S'
        save_game
        puts 'PROGRESS SAVED!'
      end
      if coordinate == 'exit' or coordinate == 'Exit' or coordinate == 'E'
        counter += 1
        save_game
        puts "Exits and saves!"
        throw :finish
      end
      x = coordinate[0]; y = coordinate[1].to_i
      counter+=1 if ((cols.include? x) && (rows.include? y))
    end
    start = []
    start[0] = cols.index(x)
    start[1] = rows.index(y)
    start     
  end
    # Prompts player for destination
  def move_to(piece)
    cols = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    rows = [1, 2, 3, 4, 5, 6, 7, 8]
    counter = 0; x = ''; y = ''
    until counter == 1
      print "Enter destination coordinates: "
      coordinate = STDIN.gets.chomp
      x = coordinate[0]; y = coordinate[1].to_i
       counter+=1 if ((cols.include? x) && (rows.include? y))
    end
    puts ''
    puts "#{piece.class} to #{x}#{y}."
    stop = []
    stop[0] = cols.index(x)
    stop[1] = rows.index(y)
    stop     
  end
    #Determines which piece player wants to move
  def piece_in_play(start)
    return $board[start[0]][start[1]]
  end
   # Searches board for location of player's king
  def find_my_king(player, board)
    board.each_with_index do |col, i| 
      col.each_index do |j|
        return [i, j] if board[i][j].class == King && board[i][j].color == player
      end
    end  
  end
    # Generates temporary board for what-if scenarios
  def temporary_board(start, stop)
    temp_board = $board.map {|line| line.dup}
    piece = piece_in_play(start)
    temp_board[stop[0]][ stop[1]] = piece
    temp_board[start[0]][ start[1]] = nil
    return temp_board
  end
  # Runs tests to ensure 1)  moving your own player 2) King not in check or not moving into check 3) not trying to capture your own piece 4) move is a legal combination 5) En passant is a possibility 6) Castling is a possibility
  def permissible(start, stop, piece, player)
    $board[start[0]][start[1]].nil? ? start_color = nil : start_color =  $board[start[0]][start[1]].color
    $board[stop[0]][stop[1]].nil? ? stop_color = nil : stop_color = $board[stop[0]][stop[1]].color 
    # Ensures player moving own piece
    if start_color != player
      puts "Invalid selection!"; return false
    end
    temp_board = temporary_board(start, stop)
    check = in_check(player, temp_board)
    # Ensures King not currently in check, or move places King in check
    if check == true
      puts ''
      puts "Invalid move. King in check." ; return false 
    end
    # Ensures player doesn't capture own piece
    if stop_color == player
      puts ''
      puts "You cannot capture your own piece!"; return false
    end
    # Permits en passant
    if  piece.class == Pawn && $board[@prev_coord[0]][@prev_coord[1]].class == Pawn
      if @prev_delta_y == 2 && @prev_coord[1] == start[1]  && @prev_coord[0] == stop[0] 
        if (player == 'white' && stop[1] == @prev_coord[1] + 1) or (player == 'black' && stop[1] == @prev_coord[1] -1 )
           print "En passant"
          $board[@prev_coord[0]][@prev_coord[1]] = nil
          return true
        end
      end
    end
    #King hasn't moved yet, rook hasn't moved yet
    if piece.class == King  and start[1] == stop[1] and (start[0] - stop[0]).abs == 2 and piece.turn == 0 #first rank King,king hasn't moved, 
       if castle_valid(start, stop, piece, player)
        print "Castling..."
        return true
       end
    end
    # Ensures move is a valid combination for piece type
    if piece.valid_move(start, stop, $board) == false
      puts ''
      puts "Invalid move!" ; return false
    end
    return true
  end
  def castle_valid(start, stop, piece, player)
    if player == 'white'
      if stop[0] == 6 && $board[7][0].class == Rook && $board[7][0].turn == 0
        if $board[stop[0]][stop[1]].nil? && $board[5][0].nil?
           temp_board = temporary_board(start, [5, 0])
           check = in_check(player, temp_board)
           if !check 
              $board[5][0] = Rook.new(player)
              $board[5][0].turn += 1
              $board[7][0] = nil
              return true    
           end
        end        
      end 
        if stop[0] == 2 && $board[0][0].class == Rook && $board[0][0].turn == 0
          if $board[stop[0]][stop[1]].nil? && $board[3][0].nil?
           temp_board = temporary_board(start, [3, 0])
           check = in_check(player, temp_board)
           if !check
              $board[3][0] = Rook.new(player)
              $board[3][0].turn += 1
              $board[0][0] = nil
              return true    
           end
         end        
        end 
    else
      if stop[0] == 6 && $board[7][7].class == Rook && $board[7][7].turn == 0
        if $board[stop[0]][stop[1]].nil? && $board[5][7].nil?
           temp_board = temporary_board(start, [5, 7])
           check = in_check(player, temp_board)
           if !check 
              $board[5][7] = Rook.new(player)
              $board[5][7].turn += 1
              $board[7][7] = nil
              return true    
           end
         end         
      end
      if stop[0] == 2 && $board[0][7].class == Rook && $board[0][7].turn == 0
          if $board[stop[0]][stop[1]].nil? && $board[3][7].nil?
           temp_board = temporary_board(start, [3, 7])
           check = in_check(player, temp_board)
           if !check 
              $board[3][7] = Rook.new(player)
              $board[3][7].turn += 1
              $board[0][7] = nil
              return true    
           end
         end        
      end 
    end
  end
    # Determines if king is in check
  def in_check(player, board)
    king_loc = find_my_king(player, board)
    dangerous_player = offending_player(king_loc, player, board)
   if dangerous_player.nil?
    return false 
   end
    return true
  end
    # Updates board, moving piece and deleting captured piece
  def move_player (start, stop, piece)
    $board[stop[0]][stop[1]] = piece
    $board[start[0]][start[1]] = nil  
    $board[stop[0]][stop[1]].turn += 1
    @prev_coord= [stop[0], stop[1]]
    @prev_delta_y = (stop[1] - start[1]).abs
    if piece.class == Pawn and (stop[1] == 7 or stop[1] == 0)
      promotion(stop, piece)
    end      
  end
  def promotion(stop, piece)
    color = piece.color
    counter = 0
    while counter < 1
      puts "To which piece would you like to promote your pawn? "
      sleep (0.1)
      print "(Q)ueen, k(N)ight, (R)ook, or (B)ishop"
      swap = gets.chomp.upcase
      case swap
        when "Q"
          $board[stop[0]][stop[1]] = Queen.new(color)
          counter += 1
        when "N"
          $board[stop[0]][stop[1]] = Knight.new(color)
           counter += 1
        when "R"
          $board[stop[0]][stop[1]] = Rook.new(color)
           counter += 1
        when "B"
          $board[stop[0]][stop[1]] = Bishop.new(color)
           counter += 1
        else  
          puts "I don't understand!"    
      end 
    end
    puts "Pawn promoted."
  end
    # Determines which player is a threat to the King (has him in check)
  def offending_player(king_loc, player, board)
    board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if board[i][j].nil?
        if board[i][j].color != player && board[i][j].valid_move([i, j], king_loc, board) == true  
          return [board[i][j], [i, j]] 
        end
     end
    end
    return nil
  end
  # Returns true if King in checkmate, ending game
  def checkmate(player)
    king_possible_combos = [[-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0] ,[1, -1], [0, -1] , [-1, -1]]
    check = in_check(player, $board)
    if check == true
      king_options = []
      current_king_loc = find_my_king(player, $board)
        king_possible_combos.each do |combo|
        location = current_king_loc.zip(combo).map {|x| x.reduce(:+)}.dup
        on_board = within_range(location)
        next if !on_board
        if $board[location[0]][location[1]].nil? 
          king_options << location
        elsif $board[location[0]][location[1]].color != player 
          king_options << location
        else
          next
        end
        end
        boards = []
      king_options.each do |option|
          boards << temporary_board(current_king_loc, option)
      end
      checks = []
      boards.each do |board|
        checks << in_check(player, board)
      end   
      player_to_rescue = possible_hero(current_king_loc, player, $board)
       return false if checks.include? false or player_to_rescue
      return true
    else
      return false
    end
  end
    # Checks to see if there is another way out of a check situation:  that another piece can either capture the threat, or block his path
  def possible_hero(king_loc, player, board)
    threat = offending_player(king_loc, player, board)[0]
    threat_loc = offending_player(king_loc, player, board)[1]
    attack_path = threat.calculate_path(threat_loc, king_loc)
    destroy_threat = []
    move_in_path = []
    board.each_with_index do |row, i|
      row.each_index do |j| 
        piece = board[i][j]
        if !piece.nil? and piece.color == player and [i, j] != king_loc
          if piece.color == player
            destroy_threat << [i, j] if piece.valid_move([i,j], threat_loc, board)
          end
         attack_path.each do |block|
          if board[block[0]][block[1]].nil? 
            move_in_path << [[i, j], block] if piece.valid_move([i,j], block, board)
          else
            move_in_path << [[i, j], block] if piece.valid_move([i,j], block, board) && board[block[0]][block[1]].color != player
          end
        end
        end    
    end
  end   
    possible_boards = []
    destroy_threat.each do |hero|
      possible_boards << temporary_board(hero, threat_loc)
    end
    move_in_path.each do |hero|
      possible_boards << temporary_board(hero[0], hero[1]) 
    end
     checks = []
    possible_boards.each do |test_board|
      checks << in_check(player, test_board)
    end   
    return true if checks.include? false
    return false
  end
    # checks to see if desired move is on the board
  def within_range(coordinates)
    return true if coordinates[0].between?(0, 7) && coordinates[1].between?(0, 7)
    return false
  end 
  def save_game
    yaml = YAML::dump(self)
    saved = File.new('saved_game.rb', 'w')
    saved.write(yaml)
    saved.close
  end
  def game_over_draw(player)
    # Future stalemate function
  end
end
 
class Pawn
  attr_accessor :color, :turn, :symbol
  def initialize(color)
    @color = color
    @turn = 0
    @symbol = symbol_generator(@color)
  end
  
  def symbol_generator(color)
   color == 'white' ? symbol = 'WP' : symbol = 'BP'
   symbol
  end
  
  def valid_move(start, stop, board)
    # valid if pawn moves 1) one space forward provided space empty 2) two spaces forward if empty and first move, or 3) diagonal to capture a piece
    if @color == "white"
      return true if board[stop[0]][stop[1]].nil? && start.zip([0, 1]).map {|x| x.reduce(:+)} == stop
      return true if board[stop[0]][stop[1]].nil? && start.zip([0, 2]).map { |x| x.reduce(:+)} == stop && @turn == 0 && board[stop[0]][stop[1]-1].nil?
      return true if !board[stop[0]][stop[1]].nil? && (start.zip([-1, 1]).map { |x| x.reduce(:+)} == stop || start.zip([1, 1]).map { |x| x.reduce(:+)} == stop)
      return false
    else
      return true if board[stop[0]][stop[1]].nil? && start.zip([0, -1]).map {|x| x.reduce(:+)} == stop
      return true if board[stop[0]][stop[1]].nil? && start.zip([0, -2]).map { |x| x.reduce(:+)} == stop && @turn == 0 && board[stop[0]][stop[1]+1].nil?
      return true if !board[stop[0]][ stop[1]].nil? && (start.zip([-1, -1]).map { |x| x.reduce(:+)} == stop || start.zip([1, -1]).map { |x| x.reduce(:+)} == stop)
      return false
    end
  end
  
  def calculate_path(start, stop)
    if (stop[1] - start[1]).abs == 2
      stop[1] > start[1] ? inc_y = 1 : inc_y = -1
      return [[start[0], start[1] + inc_y], stop]
    else
      return [stop]
    end
  end
end

class Knight
  attr_accessor :color, :symbol, :turn
  def initialize(color)
    @color = color
    @turn = 0
    @symbol = symbol_generator(@color)
  end
  def symbol_generator(color)
    color == 'white' ? symbol = 'WN' : symbol = 'BN'
    symbol
  end
  
  def valid_move(start, stop, board)
    possible_moves = [[2,1],[2,-1],[1,2],[1,-2],[-2, -1],[-1, -2],[-2, 1],[-1,2]] 
    potential = []
    possible_moves.each do |possible|
      potential << start.zip(possible).map {|pair| pair.reduce(:+)}
    end
    potential.each {|x| return true if x == stop}
    return false
  end
  
  def calculate_path(start, stop)
    return [stop]
  end
end

class Rook
  attr_accessor :color, :turn, :symbol
  #factor in castling
  def initialize(color)
    @color = color
    @turn = 0
    @symbol = symbol_generator(@color)
  end  
  
   def symbol_generator(color)
     color == 'white' ? symbol = 'WR' : symbol = 'BR'
     symbol
   end  
  # true if move is horizontal/vertical and no pieces in way
  def valid_move(start, stop, board)
    if start[0] == stop[0] && start[1] != stop[1]
      path = calculate_path(start, stop)
      path.each_with_index do |pair, i|
        return false if !board[pair[0]][pair[1]].nil? && i != path.size - 1
      end
      return true
    end
    if start[1] == stop[1] && start[0] != stop[0]
      path = calculate_path(start, stop)
      path.each_with_index do |pair, i|
        return false if !board[pair[0]][pair[1]].nil? && i != path.size - 1
      end
      return true
    end
    return false
  end
  
  def calculate_path(start, stop)
    path = []
    if start[0] == stop[0] #vertical
      stop[1] > start[1] ? inc = 1 : inc = -1
      for i in 1...(stop[1] - start[1]).abs + 1
        path << [start[0], start[1] + inc * i]
      end
    elsif start[1] == stop[1] #horizontal
      stop[0] > start[0] ? inc = 1 : inc = -1
      for i in 1...(start[0] - stop[0]).abs + 1
        path << [start[0] + inc * i, start[1]]
      end
    else
      path = []
    end
   return path
  end
  
end

class Bishop
  attr_accessor :color, :symbol, :turn
  def initialize(color)
    @color = color
    @turn = 0
    @symbol = symbol_generator(color)
  end
  
  def symbol_generator(color)
    color == 'white' ? symbol = 'WB' : symbol = 'BB'
    symbol
  end
  
  def valid_move(start, stop, board) 
    if (start[0] - stop[0]).abs == (start[1] - stop[1]).abs
      path = calculate_path(start, stop)
      for i in 0...path.size-1
        pair = path[i]
        return false if !board[pair[0]][pair[1]].nil?
      end
      return true    
    else
      return false
    end
  end
  
  def calculate_path(start, stop) 
    path = []
    stop[0] - start[0] > 0 ? inc_x = 1 : inc_x = -1
    stop[1] - start[1] > 0 ? inc_y = 1: inc_y = -1
    current = start.dup
    until current == stop
      current[0] += inc_x; current[1]+= inc_y
      path << current.dup
    end
   path
  end
end

class Queen
  attr_accessor :color, :symbol, :turn
  def initialize(color)
    @color = color
    @turn = 0
    @symbol = symbol_generator(@color)
  end
  
  def symbol_generator(color)
   color == 'white' ? symbol = 'WQ' : symbol = 'BQ'
   symbol
  end
  
  def valid_move(start, stop, board)
    path = calculate_path(start, stop)
    if path == []
      return false
    else
      for i in 0...path.size-1
        pair = path[i]
        return false if !board[pair[0]][pair[1]].nil?
      end
      return true  
    end
  end
  
  def calculate_path(start, stop)
    diff_x = stop[0] - start[0]
    diff_y = stop[1] - start[1]
    path = []
    if diff_y.abs == diff_x.abs #diagonal path
      diff_x < 0 ? x_inc = -1 : x_inc = 1
      diff_y < 0 ? y_inc = -1 : y_inc = 1
      for i in 1..diff_x.abs
        path << [start[0] + x_inc * i, start[1] + y_inc * i ]
      end
    elsif diff_x == 0 #vertical
      diff_y < 0 ? y_inc = -1 : y_inc = 1 
        for i in 1..diff_y.abs
          path << [start[0], start[1] + y_inc * i]
        end
    elsif diff_y == 0 #horizontal  
      diff_x < 0 ? x_inc = -1: x_inc = 1
      for i in 1..diff_x.abs
        path << [start[0] + x_inc * i, start[1]]
      end 
    else
      path = []
    end
    path
  end
end

class King
  attr_accessor :color, :symbol, :turn
  def initialize(color)
    @color = color
    @turn = 0
    @symbol = symbol_generator(@color)
  end
   
  def symbol_generator(color)
   color == 'white' ? symbol = 'WK' : symbol = 'BK'
   symbol
  end
  
   # code not in check!
   def valid_move(start, stop, board)
    x_diff = (stop[0] - start[0]).abs
    y_diff = (stop[1] - start[1]).abs
    return true if (x_diff == 0 || x_diff == 1) && (y_diff == 0 || y_diff ==1)
    return false
   end
   
   def calculate_path(start, stop)
    return [stop]
   end
end

# NewGame class, inherits from Game
class NewGame < Game
  def initialize
    super
    puts ''
    puts "New game!"
    puts ''
    puts 'To move, enter starting and stopping coordinates.  For example: a2, and a4.'
    puts ''
    puts '...At any time, you can type \'save\' or \'exit\'!'
    puts ''
    setup_board
    play
  end
end

class LoadGame < Game
  def initialize
    puts ''
    puts '...At any time, you can type \'save\' or \'exit\'!'
    puts ''
    YAML.load_file('saved_game.rb').play
  end
end

Game.welcome
