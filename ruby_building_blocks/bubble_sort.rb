def bubble_sort(jumbled)
	sorted = true
	
	while sorted do
		sorted = false
		
		for i in 0..jumbled.length-2
			if jumbled[i] > jumbled[i+1]
				jumbled[i], jumbled[i+1] = jumbled[i+1], jumbled[i]
				sorted = true
			end
		end
	end
	print jumbled
end

bubble_sort ([4,3,78,2,0,2])
