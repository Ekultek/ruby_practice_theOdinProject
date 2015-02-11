# Searching Binary Trees, assignment: #http://www.theodinproject.com/ruby-programming/data-structures-and-algorithms

# Dawn Pattison

# Node class, holds node value and up to two children
class Node
  attr_accessor :value, :left_child, :right_child
  def initialize(value, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end
end

#Tree class, holds tree full of nodes, can call search functions on tree
class Tree
  attr_accessor :tree
  def initialize(list)
    @tree = nil
    @list = list.sort!.uniq!
    build_tree(@list)
  end
  # Creates a ~balanced binary tree out of sorted list
  def build_tree(list)
    center_index = list.size/2
    node = Node.new(list[center_index])
    left_list , right_list = list[0...center_index], list[center_index + 1.. -1]
    node.left_child = build_tree(left_list) unless left_list.empty?
    node.right_child = build_tree(right_list) unless right_list.empty?
    @tree = node
  end
  # Searches all of one level before descending
  def breadth_first_search(target_val)
    queue = [@tree]
    loop do
      potential = queue.shift
      return potential.value if potential.value == target_val
      array_creator(queue, potential)
      return "Not Found" if queue.empty?
    end    
  end
  # Drills down entire path before choosing another
  def depth_first_search(target_val)
    stack = [@tree]
    loop do
      potential = stack.pop
      return potential.value if potential.value == target_val
      array_creator(stack, potential)
      return "Not Found" if stack.empty?
    end 
  end
  # Helper for depth and breadth first: modifies queue or stack
  def array_creator(list_type, potential)
    list_type.push potential.left_child unless potential.left_child.nil?
    list_type.push potential.right_child unless potential.right_child.nil?
  end
  #Depth first with recursion
  def dfs_rec(target_val, node = @tree)
    return "Not Found" if node.nil?
    return node.value if node.value == target_val
    left = dfs_rec(target_val, node.left_child)
    return left if left 
    right = dfs_rec(target_val, node.right_child)
    return right if right
  end
end
  
  
 puts "======TESTS========"
 z = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
 puts z.tree
 puts  "BreadthFirstSearch Test, should equal 9: #{z.breadth_first_search(9)}"
 puts "BreadthFirstSearch Test, should equal 'Not Found': #{z.breadth_first_search(10)}"
 puts "DepthFirstSearch Test, should equal 23: #{ z.depth_first_search(23)}"
 puts "DepthFirstSearch Test, should equal 'Not Found': #{z.depth_first_search(100)}"
 puts  "DepthFirstSearch with Recursion, should equal 1: #{z.dfs_rec(1)}"
 puts "DepthFirstSearch with Recursion should equal 'Not Found': #{z.dfs_rec(33)}"
