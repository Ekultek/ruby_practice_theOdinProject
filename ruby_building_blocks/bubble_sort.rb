def bubble_sort(jumbled)
	sorted = false
	
	while !sorted do
		sorted = true
		for i in 0..jumbled.length-2
			if jumbled[i] > jumbled[i+1]
				jumbled[i], jumbled[i+1] = jumbled[i+1], jumbled[i]
				sorted = false
			end
		end
	end
	print jumbled
end

bubble_sort ([4,3,78,2,0,2])
