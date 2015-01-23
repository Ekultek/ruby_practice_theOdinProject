def bubble_sort_by(jumbled)
	sorted = false
	
	while !sorted do
		sorted = true
		for i in 0..jumbled.length-2
			if yield jumbled[i] > jumbled[i+1]
				jumbled[i], jumbled[i+1] = jumbled[i+1], jumbled[i]
				sorted = false
			end
		end
	end
	print jumbled
end






bubble_sort_by(["hi","hello","hey"]) do |left,right|
	right.length - left.length
end
    