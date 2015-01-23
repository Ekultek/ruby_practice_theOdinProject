module Enumerable 

	def my_each
		i = 0
		for i in 0..self.length - 1
			yield (self[i])
			i += 1
		end
		self
	end
	
	def my_each_with_index	
		0.upto(self.length - 1) do |i|
		yield(self[i], i)
		end
	self
	end
	
	def my_select
		selected = []
		self.my_each do |i|
			selected << i if yield(i)
		end
		selected
	end
	
	def my_all?
		self.my_each do |i|
			return false unless yield(i)
		end
		return true
	end
	
	def my_any?
		self.my_each do |i|
			return true if yield(i)
		end
		return false
	end
	
	def my_none?
		self.my_each do |i|
			puts i
			return false if yield(i) 
		end
		return true
	end
	
	def my_count
		counter = 0
		self.my_each do |i|
			counter += 1 if yield(i)
		end
		print counter
			
	end
	
	def my_map(&proc)
		mapped = []
		if proc
			self.my_each do |i|
				mapped << proc.call(i)
			end
		end
		
		print mapped
	
	end
	
	def my_inject(start=0)
		result = start
		self.my_each do |i|
			result = yield(result, i)	
		
		end
		
		return result
	end
end

def multiply_els(list)
	result = list.my_inject(1) {|prod, num| prod*num}
	puts result
end

#[1,2,3].my_each {|i| puts i*3}
#['a', 'b', 'c'].my_each_with_index {|letter, i| puts "Letter is: #{letter} and index is #{i}."}

#[2, 4, 7, 9, 10, 11, 12].my_select {|i| i%2 == 0}

#[1,2,4,5,6,8,9].my_all? {|i| i%2 == 0}

#['ruby', 'html', 'css', 'javascript'].my_any? {|i| i.length == 3

#[4, 5, 7, 8, 11, 14].my_none? {|i| i % 3 == 0}

#[4, 5,8,2,9, 4, 5, 6, 4, 8, 9].my_count {|i| i}

#[4, 3, 7, 8, 9, 10, 11].my_map {|i| i*3}

#[2, 4, 6, 7, -6, 8].my_inject(0) {|sum, num| sum + num}

#multiply_els([2,3,4,5])




