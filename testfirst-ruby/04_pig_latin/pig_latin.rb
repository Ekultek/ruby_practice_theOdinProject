def translate(string)
	
	words = string.split
	final = []

	words.each do |word|
		if word.start_with?('a','e','i','o','u')
			final << word + 'ay'
		else
			if ['a', 'e', 'i', 'o', 'u'].include? word[1] 
				if word[0..1] == 'qu'
					final << word.slice(2..-1) + 'quay'
				else
					final << word.slice(1..-1)+word[0]+'ay'
				end
			elsif ['a', 'e', 'i', 'o', 'u'].include? word [2]
				if word[1..2] =='qu'
					final << word.slice(3..-1) + word[0..2] + 'ay'
				else
					final << word.slice(2..-1) + word[0..1] + 'ay'	
				end
			else 
				final << word.slice(3..-1)+word[0..2]+'ay'
						end
		end
	end
	
	return final.join(" ")

end

#1 consonant 2nd letter is a vowel
#2 consonants 3rd letter is a vowel
#3 consonants 4th letter is a vowel