#A Caesar cipher shifts every letter in the text the same number of spaces

#Second attempt:
def caesar_cipher(string, shift)

	alphabet = 'abcdefghijklmnopqrstuvwxyz'
	string = string.downcase
  translated = []
	string.each_char do |char|
		if alphabet.include? (char)
			translated<< alphabet[(alphabet.index(char) + shift) % 26]
		else
			translated << char
		end
	end
    return translated.join('')
	end

#caesar_cipher("What a string!", 5)

#First attempt: One word ciphers, has problems if same letter shows up
=begin
def caesar_cipher(string, shift)
	
	alphabet = 'abcdefghijklmnopqrstuvwxyz'
	string = string.downcase.split('')
	string.each do |char|
		newChar = (alphabet.index(char) + shift) % 26
		string[string.index(char)] = alphabet[newChar]
	end
	
	return string.join("")
end

new = caesar_cipher("Dawn", 5)
puts new

=end