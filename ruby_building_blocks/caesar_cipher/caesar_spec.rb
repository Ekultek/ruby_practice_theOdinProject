require_relative 'caesar_cipher'

describe "caesar_cipher" do 

	it "shifts input by given factor" do 
    test = caesar_cipher("dawn", 2)
    test.should == 'fcyp'
	end
  
  it "handles shifts past z" do
    caesar_cipher("zipper", 3).should == "clsshu"
  end
end