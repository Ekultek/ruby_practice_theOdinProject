class Book
	attr_accessor :title
	
	def title
		words = @title.split(" ")
		length = words.length
		i = 0
		while i < length
			words[i] = words[i].capitalize unless ['and', 'not', 'or', 'but', 'the', 'in', 'of', 'a', 'an'].include? words[i]
			i += 1
		end
		
		words[0] = words[0].capitalize
		words.join(" ")
	end	
	

end