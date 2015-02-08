list = [33, 54, 12, 25, 48, 6, 59]

def combine(a,b)
  sorted = []
  until a.size == 0 || b.size == 0
    a[0] <= b[0]? sorted << a.shift : sorted << b.shift
  end
  sorted + a + b
end

def merge_sort (list)
  if list.size == 1
    list
  else
    a = list[0...list.length/2]
    b = list[list.length/2..-1]
    a = merge_sort(a)
    b = merge_sort(b)
    combine(a,b)
  end
end

merge_sort(list)