require 'spec_helper'

describe Player do 
  before :all do
    @player = Player.new "Dawn", 'X'
  end
  
  it "stores name attribute" do
    expect(@player.name).to eql 'Dawn'
  end
  
  it "stores marker attribute" do
    expect(@player.mark).to eql 'X'
  end

end

describe Board do
  before :all do
    @game = Board.new
  end
  
  it "stores game board attribute" do
    expect(@game.board).to eql [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end
  
  describe "#draw" do
       it "replaces empty spaces on board with player mark" do
        expect(@game.draw(9, @game.player_1)).to eql [[1, 2, 3], [4, 5, 6], [7, 8, 'X']]
        expect(@game.draw(8, @game.player_1)).to eql [[1, 2, 3], [4, 5, 6], [7, 'X', 'X']]
        expect(@game.draw(7, @game.player_1)).to eql [[1, 2, 3], [4, 5, 6], ['X', 'X', 'X']]
      end
  end
  
  describe "#check" do
    before :each do
     @game.check(@game.player_1)
    end
    it "returns true if player has won" do
      expect(@game.stop).to be true
    end
  end
end