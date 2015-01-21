# Method substrings takes a word as the first argument, and word list as second argument.  Returns hash with all substrings found in original string, and how many times it was found

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

def substrings(string, dictionary)
	#creates new hash and strips punctuation from string, makes lowercase, puts in array
	hashes = Hash.new(0)
	stringArray = string.downcase.gsub(/[^a-z0-9\s]/, "").split(' ')
	temp = []
	word = 'howdy'
	
	
	#splits string array into combinations of letters, each a potential word
	stringArray.each do |word|
		
		for i in 1..word.length
			tempWord = word.split('').each_cons(i).to_a
			temp << tempWord						
		end	
		
	end
	
	#determines which potential words are actually in dictionary and adds them to hash
	temp.each do |str|
		str.each do |char|
			if dictionary.include? char.join('')
				hashes[char.join('')] = hashes[char.join('')] + 1
			end
		end
	end
	puts hashes
end

substrings("Howdy partner, sit down, how's it going?", dictionary)
