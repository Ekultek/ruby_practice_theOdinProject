require 'spec_helper'

describe "Game" do
  before :all do
    @game = Game.new
  end

  describe "#new" do
    it "creates a new instance of Game" do
      expect(@game).to be_an_instance_of Game
    end
    it "generates the game board" do
      expect($board).to eql [[nil, nil, nil, nil, nil, nil, nil, nil],[nil, nil, nil, nil, nil, nil, nil, nil],[nil, nil, nil, nil, nil, nil, nil, nil],[nil, nil, nil, nil, nil, nil, nil, nil],[nil, nil, nil, nil, nil, nil, nil, nil],[nil, nil, nil, nil, nil, nil, nil, nil],[nil, nil, nil, nil, nil, nil, nil, nil],[nil, nil, nil, nil, nil, nil, nil, nil]]
    end
    it "creates an array of the two players" do
      expect(@game.players).to eql ["white", "black"]
    end
  end
    
  describe "#setup_board" do
    before :all do 
      @game.setup_board
    end
    it "places game pieces in appropriate places" do
      expect($board[0][1].symbol).to eql 'WP'
      expect($board[0][6].symbol).to eql 'BP'
      expect($board[0][0].symbol).to eql 'WR'
      expect($board[7][7].symbol).to eql 'BR'
      expect($board[1][0].symbol).to eql 'WN'
      expect($board[1][7].symbol).to eql 'BN'
      expect($board[2][0].symbol).to eql 'WB'
      expect($board[2][7].symbol).to eql 'BB'
      expect($board[3][0].symbol).to eql 'WQ'
      expect($board[3][7].symbol).to eql 'BQ'
      expect($board[4][0].symbol).to eql 'WK'
      expect($board[4][7].symbol).to eql 'BK'
    end
  end  
  
   describe "#move_from" do
    it "requests row and column (a2) from user, outputs transformed start" do
    expect(@game.move_from).to eql [0, 1]
    end
  end
    
    describe "#move_to" do
    it "requests row and column (a4) from user, outputs transformed start" do
    expect(@game.move_to('piece')).to eql [0, 3]
    end
  end
  
  describe "#piece_in_play" do
    it "returns piece that player wants to move" do
      expect(@game.piece_in_play([1, 0])).to be_an_instance_of Knight
      expect(@game.piece_in_play([7, 0])).to be_an_instance_of Rook
      expect(@game.piece_in_play([1, 1])).to be_an_instance_of Pawn
      expect(@game.piece_in_play([3, 0])).to be_an_instance_of Queen
    end
  end
  
  describe "#find_king" do
    it "returns location of current player's king" do
      expect(@game.find_my_king('white', $board)).to eql [4, 0]
      expect(@game.find_my_king('black', $board)).to eql [4, 7]
    end
  end
  
  describe "#temporary_board" do
    it "returns temp board" do
      expect(@game.temporary_board([0, 1], [0, 3])[0][3]).to be_an_instance_of Pawn
    end
  end
  
  describe "#permissible" do
    before :all do 
      @piece = @game.piece_in_play([1,0])
      @black_rook = @game.piece_in_play([1, 7])
    end
    it "performs checks to ensure move valid" do
      expect(@game.permissible([1, 0], [3, 1], @piece, 'white')).to be false 
      expect(@game.permissible([1, 7], [2, 5], @piece, 'black')).to be true
    end
  end
  
  describe "#permissible" do
    before do 
      @game5 = Game.new
      $board[0][1] = Pawn.new('white')
      $board[0][2] = Knight.new('white')
      $board[0][4] = Pawn.new('black')
      $board[0][7] = Rook.new('black')
      $board[1][1] = Pawn.new('white')
      $board[1][5] = Pawn.new('black')
      $board[2][5] = Rook.new('black')
      $board[2][7] = Bishop.new('black')
      $board[3][1] = King.new('white')
      $board[3][2] = Knight.new('black')
      $board[3][6] = Pawn.new('black')
      $board[4][1] = Bishop.new('white')
      $board[4][3] = Pawn.new('white')
      $board[4][4] = Rook.new('white')
      $board[4][7] = King.new('black')
      $board[5][3] = Pawn.new('white')
      $board[5][7] = Bishop.new('white')
      $board[6][1] = Pawn.new('white')
      $board[6][6] = Pawn.new('black') 
      $board[7][1] = Pawn.new('white')
      $board[7][4] = Pawn.new('black')
      $board[7][6] = Knight.new('white')
      @piece5 = @game5.piece_in_play([2,5])
      @game5.print_board($board)
    end
     it "returns true if player moves in the path of threat and King" do
      expect(@game5.permissible([2, 5], [4, 5], @piece5, 'black')).to be true 
    end
  end
  
  describe "#move_player" do
    before do
      @game = Game.new
      @game.setup_board
      @piece = @game.piece_in_play([1,0])
      @game.move_player([7, 3], [7, 4], @piece)
    end
    it "updates board, moving piece, and taking opponent, if applicable" do
      expect($board[7][4]).to eql @piece
    end
  end
  
  describe "#checkmate" do
    before do 
      $board[7][4] = nil
      @pawnf2 = @game.piece_in_play([5, 1])
      @game.move_player([5, 1], [5, 2], @pawnf2)
      @pawne5 = @game.piece_in_play([4, 6])
      @game.move_player([4, 6], [4, 4], @pawne5)
      @pawng2 = @game.piece_in_play([6, 1])
      @game.move_player([6, 1], [6, 3], @pawng2)
      @queend5 = @game.piece_in_play([3, 7])
      @game.move_player([3, 7], [7, 3], @queend5)
      @game.print_board($board)
    end
    it "returns true if player in checkmate" do
      expect(@game.checkmate('white')).to be true
    end
   end
  
  describe "#checkmate" do
    before do
      @game2 = Game.new
      @game2.setup_board
      @game2.move_player([4, 1], [4, 2], @game2.piece_in_play([4, 1]))
      @game2.move_player([3, 0], [5, 2], @game2.piece_in_play([3, 0]))
      @game2.move_player([5, 0], [2, 3], @game2.piece_in_play([5, 0]))
      @game2.move_player([5, 2], [5, 6], @game2.piece_in_play([5, 2]))
      #@game2.print_board($board)
   end
    it "returns true if player in checkmate" do
      expect(@game2.checkmate('black')).to be true
    end
  end
  
  describe "#checkmate" do
    before do
      @game3 = Game.new
      $board[0][1] = Pawn.new('white')
      $board[0][5] = Pawn.new('black')
      $board[1][1] = Pawn.new('white')
      $board[1][4] = Bishop.new('white')
      $board[1][6] = Pawn.new('black')
      $board[1][7] = Rook.new('black')
      $board[2][0] = King.new('white')
      $board[2][1] = Pawn.new('white')
      $board[2][2] = Knight.new('white')
      $board[2][6] = Queen.new('black')
      $board[2][7] = Bishop.new('black')
      $board[3][0] = Rook.new('white')
      $board[3][1] = Queen.new('white')
      $board[3][3] = Knight.new('white')
      $board[3][5] = Pawn.new('black')
      $board[4][3] = Pawn.new('white')
      $board[4][4] = Pawn.new('black')
      $board[4][7] = King.new('black')
      $board[5][3] = Pawn.new('white')
      $board[5][5] = Knight.new('black') 
      $board[5][6] =Pawn.new('black')
      $board[5][7] = Bishop.new('black')
      $board[6][0] = Bishop.new('white')
      $board[6][3] = Knight.new('black')
      $board[6][6] = Pawn.new('black')
      $board[7][0] = Rook.new('white')
      $board[7][1] = Pawn.new('white')
      $board[7][5] = Pawn.new('black')
      $board[7][7] = Rook.new('black')
      #@game3.print_board($board)
   end
    it "returns true if player in checkmate" do
      expect(@game3.checkmate('black')).to be false
    end
  end
  
   describe "#checkmate" do
    before do
      @game4 = Game.new
      $board[0][1] = Pawn.new('white')
      $board[0][6] = Pawn.new('black')
      $board[0][7] = Rook.new('black')
      $board[1][1] = Pawn.new('white')
      $board[1][6] = Pawn.new('black')
      $board[1][7] = Knight.new('black')
      $board[2][0] = King.new('white')
      $board[2][1] = Pawn.new('white')
      $board[2][2] = Knight.new('white')
      $board[2][5] = Pawn.new('black')
      $board[2][7] = Bishop.new('black')
      $board[3][0] = Rook.new('white')
      $board[3][7] = King.new('black')
      $board[4][4] = Queen.new('black')
      $board[4][5] = Pawn.new('black')
      $board[5][0] = Bishop.new('white')
      $board[5][1] = Pawn.new('white')
      $board[5][6] = Pawn.new('black')
      $board[5][7] = Bishop.new('black')
      $board[6][1] = Pawn.new('white') 
      $board[6][4] =Bishop.new('white')
      $board[6][6] = Pawn.new('black')
      $board[7][0] = Rook.new('white')
      $board[7][1] = Pawn.new('white')
      $board[7][6] = Pawn.new('black')
      $board[7][7] = Rook.new('black')
      #@game4.print_board($board)
   end
    it "returns true if player in checkmate" do
      expect(@game4.checkmate('black')).to be false
    end
  end
  
   describe "#checkmate" do
    before do
      @game4 = Game.new
      $board[0][5] = King.new('white')
      $board[0][7] = King.new('black')
      $board[2][7] = Rook.new('white')
      #@game4.print_board
   end
    it "returns true if player in checkmate" do
      expect(@game4.checkmate('black')).to be true
    end
  end
  
end

describe "Pawn" do
before do
    @game = Game.new
    @game.setup_board
  end
  before :all do
    @wpawn = Pawn.new("white")
    @bpawn = Pawn.new("black")
  end
  
  describe "#new" do
    it "creates an instance of Pawn" do
      expect(@wpawn).to be_an_instance_of Pawn
      expect(@bpawn).to be_an_instance_of Pawn
    end
    it "creates Pawn of a certain color" do
      expect(@wpawn.color).to eql "white"
      expect(@bpawn.color).to eql "black"
    end
    it "instantiates Pawn's turn as 0" do
      expect(@wpawn.turn).to eql 0
      expect(@bpawn.turn).to eql 0
    end
  end
  
  describe "calculate_path" do
    it "calculates path excluding start space" do
      expect(@wpawn.calculate_path([0,1], [0, 3])).to eql  [[0,2], [0,3]]
      expect(@wpawn.calculate_path([0,1], [0, 2])).to eql  [[0,2]]
      expect(@wpawn.calculate_path([0,1], [1, 2])).to eql  [[1,2]]
      expect(@wpawn.calculate_path([1,1], [0, 2])).to eql  [[0,2]]
      expect(@bpawn.calculate_path([0,6], [0, 4])).to eql  [[0,5], [0,4]]
      expect(@bpawn.calculate_path([0,6], [0, 5])).to eql  [[0,5]]
      expect(@bpawn.calculate_path([0,6], [1, 5])).to eql  [[1,5]]
      expect(@bpawn.calculate_path([1,6], [0, 5])).to eql  [[0,5]]
    end
  end
  
  describe "#valid_move" do
    before :all do
      @wtest_move_one = @wpawn.valid_move([0, 1], [0, 2], $board)
      @btest_move_one = @bpawn.valid_move([0, 6],[0, 5], $board)
      @wpawn.turn = 1
      @bpawn.turn = 1
      @wtest_move_two = @wpawn.valid_move([0, 1], [0, 3], $board)
      @btest_move_two = @bpawn.valid_move([0, 6], [0, 4], $board)
      @wpawn.turn = 0
      @bpawn.turn = 0
      @wtest_spot_occupied = @wpawn.valid_move([0, 5], [0, 6], $board)
      @btest_spot_occupied = @bpawn.valid_move([3, 2], [3, 1], $board)
      @wtest_capture = @wpawn.valid_move([0, 5],[1, 6], $board)
      @btest_capture = @bpawn.valid_move([0, 2],[1, 1], $board)
    end
 
    it "returns true pawn moves one space forward to empty square" do
      expect(@wtest_move_one).to be true
      expect(@btest_move_one).to be true
    end   
    it "returns false if pawn moves two squares and not first turn " do
      expect(@wtest_move_two).to be false
      expect(@btest_move_two).to be false
    end
    it "returns false if space is full" do
      expect(@wtest_spot_occupied).to be false
      expect(@btest_spot_occupied).to be false
    end  
    it "returns true if move is diagonal and space occupied" do
      expect(@wtest_capture).to be true
      expect(@btest_capture).to be true
    end
  end
end

describe "Knight" do
  before :all do
    @wknight = Knight.new("white")
    @bknight = Knight.new("black")
  end
  
  describe "#new" do 
    it "creates a Knight" do
      expect(@wknight).to be_an_instance_of Knight
      expect(@bknight).to be_an_instance_of Knight
    end
    it "creates knight of certain color" do
      expect(@wknight.color).to eql "white"
      expect(@bknight.color).to eql "black"
    end
  end
  
  describe "#valid_move" do
    before :all do
      @wfirst_test = @wknight.valid_move([1, 0],[2, 2], $board)
      @bfirst_test = @bknight.valid_move([1, 7],[0, 5], $board)
      @wsecond_test = @wknight.valid_move([2, 2],[2, 3], $board)
      @bsecond_test = @bknight.valid_move([0, 5],[0, 4], $board)
    end
    it "returns true if knight on acceptable space" do
      expect(@wfirst_test).to be true
      expect(@bfirst_test).to be true
    end 
    
    it "returns false if knight on unacceptable space" do
      expect(@wsecond_test).to be false
      expect(@bsecond_test).to be false
    end
  end
  
  describe "calculate_path" do
    it "returns destination for knight" do
    expect(@wknight.calculate_path([0,0], [2,1])).to eql [[2,1]]
    expect(@bknight.calculate_path([3, 7], [2, 5])).to eql [[2, 5]]
    end
  end
end

describe "Rook" do
  before :all do 
    @wrook = Rook.new("white")
    @brook = Rook.new("black")
  end
  
  describe "#new" do
    it "creates a new instance of Rook" do
      expect(@wrook).to be_an_instance_of Rook
      expect(@brook).to be_an_instance_of Rook
    end
  end
  
  describe "#valid_move" do
    before :all do
      @wtest_one = @wrook.valid_move([3, 2], [3, 5], $board)
      @btest_one = @brook.valid_move([7, 5], [5, 5], $board)
      @wtest_two = @wrook.valid_move([2, 2],[2, 7], $board)
      @btest_two = @wrook.valid_move([0, 1],[5, 1], $board)
    end
    
    it "returns true if horizontal/vertical move over multiple spaces" do
      expect(@wtest_one).to be true
      expect(@btest_one).to be true
    end
    
    it "returns false if path is blocked" do
      expect(@wtest_two).to be false
      expect(@btest_two).to be false
    end
  end
  
  describe "#calculate_path" do 
    it "calculates path from a to b" do
      expect(@wrook.calculate_path([0, 0],[0, 5])).to match_array [[0, 1], [0, 2], [0, 3], [0, 4], [0,5]]
      expect(@wrook.calculate_path([7, 7], [3, 7])).to match_array [[6, 7], [5, 7], [4, 7], [3, 7]]
    end
  end
end

describe "Bishop" do
  before :all do
    @bishop = Bishop.new("white")
  end
  
  describe "#new" do
    it "creates a Bishop" do
      expect(@bishop).to be_an_instance_of Bishop
    end
    
    describe "#calculate_path" do
      it "determines the path between a and b" do
        expect(@bishop.calculate_path([2, 0], [5, 3])).to match_array [[3, 1], [4, 2], [5, 3]]
        expect(@bishop.calculate_path([7, 7], [0, 0])).to match_array [[6, 6], [5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [0,0]]
        expect(@bishop.calculate_path([0, 7], [7, 0])).to match_array [[1, 6], [2, 5], [3, 4], [4, 3], [5, 2], [6, 1], [7,0]]
      end
    end
    
    describe "#valid_move" do 
      it "returns true if path clear and move is diagonal" do
      expect(@bishop.valid_move([1, 1], [7, 7], $board)).to be false
      expect(@bishop.valid_move([5, 2], [2, 5], $board)).to be true
      expect(@bishop.valid_move([6, 4], [3, 8], $board)).to be false
      end
    end
  end
end

describe "Queen" do

  before :all do
    @queen = Queen.new('white')
  end
  
  describe "#new" do
    it "creates a Queen" do
      expect(@queen).to be_an_instance_of Queen
    end
  end
  
  describe "#calculate_path" do
    it "calculates path from a to b" do
      expect(@queen.calculate_path([0, 0], [0, 7])).to match_array [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0,7]]
      expect(@queen.calculate_path([7, 7], [0, 0])).to match_array [[6, 6], [5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [0,0]]
      expect(@queen.calculate_path([6, 3], [0, 3])).to match_array [[5, 3], [4, 3], [3, 3], [2, 3], [1, 3], [0,3]]
      expect(@queen.calculate_path([0, 0], [1, 2])).to eql []
      expect(@queen.calculate_path([0,0], [1, 1])).to eql [[1,1]]
    end
  end
  
  describe "#valid_move" do
    it "returns true if path empty and valid path" do
      expect(@queen.valid_move([3, 1], [3, 7], $board)).to be false #piece in way
      expect(@queen.valid_move([1, 1], [2, 3], $board)).to be false
      expect(@queen.valid_move([4, 5], [2, 3], $board)).to be true
      expect(@queen.valid_move([5, 6], [4, 7], $board)).to be true
    end
  end  
end

describe "King" do
  before :all do 
    @king = King.new('white')
  end
  
  describe "#new" do
    it "creates a new King" do
      expect(@king).to be_an_instance_of King
    end
    
  describe "#valid_move" do
    it "returns true if King moving one space in any direction" do
      expect(@king.valid_move([1, 1],[1, 2], $board)).to be true
      expect(@king.valid_move([1, 1],[1, 0], $board)).to be true
      expect(@king.valid_move([1, 1],[0, 1], $board)).to be true
      expect(@king.valid_move([1, 1],[0, 0], $board)).to be true
      expect(@king.valid_move([1, 1],[3, 3], $board)).to be false
    end
  end
  end
end