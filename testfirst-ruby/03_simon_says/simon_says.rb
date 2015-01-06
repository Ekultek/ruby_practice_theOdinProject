def echo(text)
	text
end

def shout(text)
	text.upcase
end

def repeat(text, number=2)
	empt = []
	number.times do
		empt << text
	end
	
	return empt.join(" ")
end

def start_of_word(word, num=0)
	word[0...num]
end

def first_word(string) 
	string.split(" ").first
end

def titleize(string)
	i = 0
	array = string.split
	while i < string.split.length
		array[i] = array[i].capitalize unless array[i] == "and" || array[i] == "the" || array[i] == "over"
		i += 1
	end
	array.first.capitalize!
	array.join(" ")
end

