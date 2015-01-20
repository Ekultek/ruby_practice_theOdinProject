#stock_picker, takes in stock price array, returns which day is best to buy, which is best to sell
 
 
def stock_picker (prices)
	
	currentMax = 0
	len = prices.length
	
	for i in 0..len-2
		maximum = prices[i+1..-1].max
		if maximum - prices[i] >= currentMax
			buySell = [i, prices.index(maximum)]
			currentMax = maximum - prices[i]
		end
		
	end
	
	puts "Buy on day #{buySell[0]} and sell on day #{buySell[1]}"
end


puts stock_picker([17, 3, 6, 8, 15, 8, 6, 1, 10])