require_relative 'caesar_cipher'

describe "caesar_cipher" do 

	it "shifts input by given factor" do 
    test = caesar_cipher("dawn", 2)
    test.should == 'fcyp'
	end
  
  it "handles shifts past z" do
    caesar_cipher("zipper", 3).should == "clsshu"
  end
  
  it "handles multiple words" do
    caesar_cipher("the odin project", 4).should == "xli shmr tvsnigx"
  end
  
  it "doesn't translate punctuation" do
    caesar_cipher("Friday!&$##", 2).should == "htkfca!&$##"
  end
  
  it "handles no shift" do
    caesar_cipher("dawn", 0).should == "dawn"
  end
end