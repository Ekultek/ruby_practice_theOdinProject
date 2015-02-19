require 'spec_helper'

describe Player do
  before :all do
    @player = Player.new( "\u{25cb}")
  end
  
  describe "#new"do
    it "takes two parameters and returns a Player object" do
      expect(@player).to be_an_instance_of Player
    end
  end
  
end

describe Game do
  before :all do
    @game = Game.new
  end
  
  describe "#new"do
    it "returns a Game object" do
       expect(@game).to be_an_instance_of Game
    end
    it "creates instances of Player" do
      expect(@game.player1.marker).to eql "\u25cb"
      expect(@game.player2.marker).to eql "\u25a0"
    end
  end
  
  describe "#board" do
    it "returns an empty connect four board populated with underscore" do
      expect(@game.board).to eql [["_", "_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_", "_"]]
    end
  end
  
  describe "#choose_column" do
    it "gets valid column from player" do
      expect(@game.choose_column(@game.player1)).to be_between(0, 6).inclusive
    end
  end
  
  describe "#empty_slot" do
    it "finds first empty slot in column" do
      expect(@game.empty_slot(0)).to eql 0
    end
  end
  
  describe "#place_piece" do
     before :all do
        @game.place_piece(0, @game.player1)
        @game.place_piece(1, @game.player2)
        @game.place_piece(1, @game.player2)
        @game.place_piece(1, @game.player2)
        @game.place_piece(1, @game.player2)
        @game.place_piece(2, @game.player1)
        @game.place_piece(3, @game.player1)
        @game.place_piece(4, @game.player1)
        @game.place_piece(5, @game.player1)
        @game.place_piece(2, @game.player1)
        @game.place_piece(3, @game.player1)
        @game.place_piece(3, @game.player1)
        @game.place_piece(6, @game.player2)
        @game.place_piece(5, @game.player2)
        @game.place_piece(4, @game.player2)
        @game.place_piece(4, @game.player2)
        @game.place_piece(4, @game.player1)
        @game.place_piece(5, @game.player1)
        @game.place_piece(5, @game.player2)
        @game.place_piece(5, @game.player1)
        
    end
    it "drops piece into board" do
      expect(@game.board[0][0]).to eql "\u{25cb}"
      expect(@game.board[0][1]).to eql "\u{25a0}"
    end
  end
  
  describe "#board" do
    it "updates board attribute" do
      expect(@game.board).to eql [["\u25CB", "\u25A0", "\u25CB", "\u25CB", "\u25CB", "\u25CB",
                                                          "\u25A0"], ["_", "\u25A0", "\u25CB", "\u25CB", "\u25A0", "\u25A0",
                                                          "_"], ["_", "\u25A0", "_", "\u25CB", "\u25A0", "\u25CB", "_"], ["_",
                                                          "\u25A0", "_", "_", "\u25CB", "\u25A0", "_"], ["_", "_", "_", "_", "_",
                                                          "\u25CB", "_"], ["_", "_", "_", "_", "_", "_", "_"]]
    end
  end
  
  describe "#print_board"  do
    it "prints out nicely formatted board" do
    expect(@game.print_board).to eql nil
    end
  end
  
  describe "#inspect_row" do
    it "prints array of spaces where player marker is found" do
      expect(@game.inspect_row(@game.player1)).to eql [[0, 2, 3, 4, 5], [2,3], [3, 5],[4],[5]]
    end  
  end
  
  describe "#inspect_column" do
    it "finds player's markers in column" do
      expect(@game.inspect_column(@game.player2)).to eql [[0, 1, 2, 3], [1, 2], [1, 3], [0]]
    end
  end
  
  describe "#split_consecutive" do
    it "breaks array into smaller arrays of consecutive integers" do
      expect(@game.split_consecutive( [[0, 2, 3, 4, 5], [2,3], [3]])).to eql [[0], [2,3,4,5], [2,3], [3]]
     expect(@game.split_consecutive([])). to eql []
    end
  end
  
  describe "#longest_streak" do
    it "returns largest consecutive sequence" do
      expect(@game.longest_streak([[0], [2,3,4,5], [2,3], [3]])).to eql 4
      expect(@game.longest_streak([])).to eql 0
    end
  end
  
  describe "#inspect_rdiagonal" do
    it "finds player markers on right diagonal" do
      expect(@game.inspect_rdiagonal(@game.player1)).to eql [[0], [1,2,3,4], [0, 1], [0,2]]
    end
  end
  
  describe "#inspect_ldiagonal" do
   it "finds player markers on left diagonal" do
      expect(@game.inspect_ldiagonal(@game.player1)).to eql [[0,1], [0,1], [0, 2], [2,3]]
    end
  end 
  
  describe "#check_four" do
    it "checks board and returns true if player has four in a row" do 
      expect(@game.check_four(@game.player1)).to be true
      expect(@game.check_four(@game.player2)).to be true
    end
  end
  
  describe "#board_full" do
    it "returns false if board not full" do
      expect(@game.board_full).to be false
    end
  end
  
  # describe "#acceptable_choice" do
    # it "returns row/col if space not taken" do 
       # expect(@game.acceptable_choice(@game.player1)).to eql [1,0]
    # end
 # end
  end
