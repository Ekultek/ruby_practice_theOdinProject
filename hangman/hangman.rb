# Hangman 
# Dawn Pattison

require 'yaml'

# Contains all major game functions
class Game
  def initialize
    @word = select_word.split('')
    @word_blanks = Array.new(@word.length)
    @chances = 10
    @wrong_letters = []
  end
  
  def self.welcome_script
    puts ''
    print '============================='.center(10)
    print 'Welcome to HANGMAN!'.center(10)
    print '============================='.center(10)
    puts ''
    loop do
      puts ''
      print 'Press (L) to load saved game or (N) to start new game or (E) to exit!: '.center(10)
      @input = gets.chomp.upcase
      if @input == 'L'
        if File.exist? ('saved_game.rb')
          LoadGame.new
        else
          puts 'There are no games saved!'
      end
      elsif @input == 'N'
        NewGame.new
      elsif @input == 'E'
        print 'BYE!'
        return
      else
        puts "I don't understand!"
      end
    end 
   end
   
  def select_word
    dictionary = File.read('5desk.txt').split("\n")
    word = ''
    word = dictionary.sample.downcase until word.length > 5 && word.length < 12
    word
  end
  
  def play
    loop do 
      print_word_blanks
      print_incorrect_letters
      letter = @player.guess
      check(letter)
      draw(@player.bad_guesses)
      if player_wins
        puts @word.join('').upcase
        puts "#{@player.name.capitalize}, you win!"
        return
      elsif player_hanged
        puts "Correct answer: #{@word.join('').upcase}."
        puts ' '
        puts "You've been hanged!"
        return
      end
    end
  end
  
  def print_word_blanks
    puts ''
    @word_blanks.each  do |blank|
      if blank.nil?  
        print '_ '
      else
        print blank + ' '      
      end
    end
    puts ' '
  end
  
  def check(letter)
    if @word_blanks.include? letter or @wrong_letters.include? letter
      puts 'LETTER ALREADY GUESSED.'
    elsif letter == 'save'
      save_game
      puts 'PROGRESS SAVED!'
    else
      match = @word.each_index.select { |i| @word[i] == letter }
      match == [] ? hang(letter) : correct(letter, match)
    end
  end
  
  def hang(letter)
    @player.bad_guesses += 1
    @wrong_letters << letter 
  end
  
  def print_incorrect_letters
    puts ''
    puts "Incorrect letters(#{@player.bad_guesses}): #{@wrong_letters.sort.join(' ')}"
  end
  
  def correct(letter, match)
    match.each { |i| @word_blanks[i] = letter }
  end
  
  def draw(mark)
    puts ''
    case mark
    when 0
      6.times { puts }
    when 1
      puts "  '  ".center(10)
      puts '  O  '.center(10)
      4.times { puts }
    when 2
      puts "  '  ".center(10)
      puts '\ O  '.center(10)
      4.times { puts }
    when 3
      puts "  '  ".center(10)
      puts '\ O  '.center(10)
      puts ' \   '.center(10)
      3.times { puts }
    when 4
      puts "  '  ".center(10)
      puts '\ O /'.center(10)
      puts ' \   '.center(10)
      3.times { puts }
    when 5
      puts "  '  ".center(10)
      puts '\ O /'.center(10)
      puts ' \ / '.center(10)
      3.times { puts }
    when 6
      puts "  '  ".center(10)
      puts '\ O /'.center(10)
      puts ' \ / '.center(10)
      puts '  |  '.center(10)
      2.times { puts }
    when 7
      puts "  '  ".center(10)
      puts '\ O /'.center(10)
      puts ' \ / '.center(10)
      puts '  |  '.center(10)
      puts ' /   '.center(10)
      puts ''
    when 8
      puts "  '  ".center(10)
      puts '\ O /'.center(10)
      puts ' \ / '.center(10)
      puts '  |  '.center(10)
      puts ' / \ '.center(10)
      puts ''
    when 9
      puts "  '  ".center(10)
      puts '\ O /'.center(10)
      puts ' \ / '.center(10)
      puts '  |  '.center(10)
      puts ' / \ '.center(10)
      puts '/    '.center(10)
    else
      puts "  '  ".center(10)
      puts '\ O /'.center(10)
      puts ' \ / '.center(10)
      puts '  |  '.center(10)
      puts ' / \ '.center(10)
      puts '/   \\'.center(10)
      puts ''
    end
  end
  
  def player_wins
    return true if @word == @word_blanks
  end
  
  def player_hanged
    return true if @player.bad_guesses == @chances
  end
  
  def save_game
    yaml = YAML::dump(self)
    saved = File.new('saved_game.rb', 'w')
    saved.write(yaml)
    saved.close
  end
end

# Player class, contains current letter guessed
class Player
  attr_accessor :name, :bad_guesses
  def initialize
    @name = request_name
    @bad_guesses = 0
  end
  
  def request_name
    print 'Enter your name, kind sir or madam: '
    name = gets.chomp
  end
  
  def guess
    puts ''
    sleep(0.5)
    print "#{@name.capitalize}, guess a letter: "
    letter = gets.chomp.downcase
  end
end
# NewGame class, inherits from Game
class NewGame < Game
  def initialize
    super
    puts ''
    puts 'At any time, you can type \'save\'!'
    puts ''
    @player = Player.new
    play
  end
end

class LoadGame < Game
  def initialize
    puts ''
    puts 'At any time, you can type \'save\'!'
    puts ''
    YAML.load_file('saved_game.rb').play
  end
end

Game.welcome_script
