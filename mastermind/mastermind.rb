# MASTERMIND
# 12 TRIES AGAINST A NOT-SO-SMART COMPUTER!

class Game
   attr_accessor :active_player_wins
  def initialize
    @players = [Human.new, Computer.new]
    @active_player_index = 0
    @active_player_guess = []
    @num_tries = 12
  end
  
  def play
    welcome_script
    loop do
      player_guess(active_player)
      feedback(opponent, @active_player_guess) 
      if player_wins
        puts "#{active_player.name} WINS!"
        puts "#{opponent.name}'s secret code: #{opponent.secret_code}"
        puts "#{active_player.name}'s secret code: #{active_player.secret_code}"
        return
      elsif tries_exceeded
        puts "#{active_player.name}, number of tries exceeded. GAME OVER"
        return
       end
       next_turn
     end
  end
  
  def welcome_script
   puts "WELCOME TO MASTERMIND!"
   puts " "
  end
  
  def active_player
    @players[@active_player_index]
  end
  
  def player_guess(player)
    @active_player_guess = player.choose_wisely
  end
  
  def other_player_index
    1 - @active_player_index
  end
  
  def opponent
    @players[other_player_index]
  end
  
  def feedback(opponent, try)
    opponent.respond(try, active_player)
  end
  
  def player_wins
    return true if active_player.right_place == 4  
  end
  
  def tries_exceeded
    return true if active_player.turns == @num_tries
  end
  
  def next_turn
    @active_player_index = other_player_index
  end

end

class Human
  attr_accessor :name, :secret_code, :guess_record, :turns, :right_place, :right_number
  def initialize
    @name = name_prompt
    @secret_code = create_code
    @guess_record = []
    @turns = 0
    @right_place = 0
    @right_number = 0
    
  end
  
  def name_prompt
    puts ' '
    print 'Enter name: '
    gets.chomp
  end
  
  def create_code
    puts ' '
    complete = false
    until complete == true
      print 'Enter four-digit secret code using (0-9). Each digit must be unique: '
      response = gets.chomp
      code = response.to_i
      code = convert_to_list(code)
      first_digit_zero(response, code)
      complete = check_input(code)
    end
    puts "Your code is: #{code.join('-')}"
    return code
  end
  
  def first_digit_zero(text_guess, array_guess)
      array_guess.unshift(0) if text_guess[0] == '0'
  end
  
  def convert_to_list(input)
    input.to_s.scan(/./).map {|char| char.to_i}
  end
  
  def check_input(code)
        code.length == 4 ? true : false
  end
  
  def choose_wisely
    puts " "
    complete = false
    until complete == true
      print "#{@name}, try to guess Computer's code: "
      guess = gets.chomp
      guessed = guess.to_i
      guessed = convert_to_list(guessed)
      first_digit_zero(guess, guessed)
      complete = check_input(guessed)
    end
    @guess_record << guessed
    @active_player_guess = guessed
  end
  
  def print_guess_record
  puts ''
    puts "#{@name.upcase}'S GUESS LOG: ".center(40)
    @guess_record.each do |line|
      puts line.join('  ').center(40)
    end
   end
    
  
  def respond(attempt, player)
    attempt.each_with_index do |num, i|
      if num == @secret_code[i]
        player.guess_record[i] = num 
      elsif
      @secret_code.include? num 
        unless player.mandatory.include? num
        player.mandatory << num
        end
      end
    end
    if attempt == @secret_code
      player.right_place =4
    end
  end
 
end

class Computer
  attr_accessor :name, :secret_code, :guess_record, :possible, :mandatory, :turns, :right_place
  def initialize
    @name = 'Computer'
    @secret_code = create_code
    @turns = 0
    @guess_record =Array.new(4)
    @possible = Array (0..9)
    @mandatory = []
    @right_place = 0
  end
  
  def create_code
    sleep(0.5)
    code = []
    possible = Array (0..9)
    for i in 1..4
      code << possible.sample
      possible.delete code[-1]
    end
    return code
  end
  
  def choose_wisely
    puts ' '
    print 'Computer guesses: '
    sleep(0.5)
    @turns += 1
    if @turns == 1
      guessed = create_code
    else 
      guessed = @guess_record.dup
      selection = update_possible(guessed)
      while @mandatory.size < guessed.count(nil) 
        used =  selection.sample
        @mandatory << used
        selection.delete(used)
      end
     end
     guessed.each_with_index do |num, i|
        if num == nil
          guessed[i] = @mandatory.sample
          @mandatory.delete(guessed[i])
        end
     end
   puts "#{guessed} "
    @active_player_guess = guessed
  end
  
  def update_possible(guessed)
    selection = @possible.dup
    @mandatory.each do |use|
      selection.delete(use)
     end
     
     for i in guessed
      if selection.include? i
        selection.delete(i)
       end
     end
     return selection
   end
  
  def respond(attempt, player)
    player.turns += 1
    player.right_place = 0
    player.right_number = 0
    attempt.each_with_index do |num, i|
      player.right_place += 1 if num == @secret_code[i]
      player.right_number += 1 if @secret_code.include? num
    end
    player.right_number -= player.right_place
    player.guess_record[-1] << ["Right place: #{player.right_place}, Right number: #{player.right_number}."]
    player.print_guess_record
  end
end
  
z = Game.new
z.play
