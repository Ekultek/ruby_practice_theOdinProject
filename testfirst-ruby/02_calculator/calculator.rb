def add(num1, num2)
	num1 + num2

end

def subtract (num1, num2)
	num1 - num2
end


def sum(array)
	array.inject(0) {|sum, i| sum + i}
end

def multiply(array)
	prod = 1
	array.each {|i| prod *= i}
	prod
end

def power(base, power)
	base**power

end

def factorial(number)
	if number == 0 || number ==1
		return 1
	else
		fact = 1
		while number !=1
			fact *= number
			number -= 1
		return fact
	end

end
end