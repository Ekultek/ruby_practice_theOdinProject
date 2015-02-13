# Outputs fastest path for knight to move from one spot to another on a chess board

class LocationPath
    attr_accessor :location, :path
  def initialize(location, path)
    @location = location
    @path = path
  end
end

def knight_moves (start, stop)
  queue = [LocationPath.new(start, [start])]
  loop do
    potential = queue.shift
    return potential.path if potential.location == stop
    create_generation(potential.location).each do |move|
        queue.push(path_append(potential, move))
    end
  end
end

def path_append(potential, new_spot)
  new_path = potential.path + [new_spot]
  LocationPath.new(new_spot, new_path)
end

def create_generation(start)
  generation =[]
  possible = [[1, 2], [2, 1], [-2, 1], [1, -2], [-1, 2], [2, -1], [-1, -2], [-2, -1]]
  possible.each do |move|
    if on_board(move, start)
      generation << (start.zip(move).map { |x, y| x + y})
    end
  end
  return generation  
end

def on_board(move, start)
  combine = move + start
  x = combine[0] + combine[2]
  y = combine[1] + combine[3]
  return true if x.between?(0,8) && y.between?(0,8)
  return false
end

puts "Fastest path from [0, 0] to [5, 7] is: #{knight_moves([0, 0],[5, 7])}"
puts "Fastest path from [0, 0] to [1, 1] is: #{knight_moves([0, 0],[1, 1])}"
puts "Fastest path from [0, 0] to [3, 4] is: #{knight_moves([0, 0],[3, 4])}"

