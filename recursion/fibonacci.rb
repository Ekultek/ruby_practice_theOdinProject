# Fibonacci sequence: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144

# Fibonacci with iteration
def fibs(number)
  i = 0; j = 1; counter = 1
  until counter == number
    i, j = j, i+j
    counter += 1
  end
  j
end

# Fibonacci with recursion

def fibs_rec(number)
  number == 1 || number == 2? 1 : fibs_rec(number - 1) + fibs_rec(number - 2)
end



