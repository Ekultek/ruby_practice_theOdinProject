require 'spec_helper'

# tests for my_select, my_any? my_all?, my_count, my_map, my_inject
describe "my_select" do
  subject {[1, 2, 3, 5, 7, 8]}
  
  it "selects multiple items" do
    expect(subject.my_select {|num| num.even?}).to eql ([2, 8])
  end 
 
  it "selects the only relevant item" do
    expect(subject.my_select {|num| num < 2}).to eql [1]
  end
  
  it "returns empty list when none meet criteria" do
    expect(subject.my_select {|num| num%6 == 0}).to eql []
  end  
end

describe "my_any?" do
  subject {[11, 22, 33, 44, 55, 'dawn']}
  it "returns true when one element matches" do
    expect(subject.my_any? {|i| i.class == String}).to be true
  end
  
  it "throws error when comparison not possible" do
    expect{subject.my_any? {|i| i < 0 }}.to raise_error
  end
  
  it "returns false when no elements match" do
    expect([4, 8, 12, 16].my_any? {|i| i.odd?}).to be false
  end
end

describe "my_all?" do
  it "returns true if all items meet criteria" do
    expect([1, 2, 3, 6, 99, 0].my_all? {|i| i.integer?}).to be true
  end
  
  it "returns false if one item doesn't meet criteria" do
    expect([3.66, 7, 4.51, 98.7].my_all? {|i| i%1 != 0}).to be false
  end
end

describe "my_count" do
  it " returns count if no block" do
    expect([1, 2, 3, 4, 5, 6].my_count).to eql 6
  end
  
  it "counts elements from block that are true" do
      expect([0, 1, 2, 3, 4, 5, 6].my_count {|i| i.even?}).to eql 4
  end  
  
  it "returns 0 when nothing in array matches block criteria" do
    expect([0, 1, 2, 3, 4, 5, 6].my_count {|i| i > 100}).to eql 0
  end
end

describe "my_map" do

  it "maps every element to another" do
    expect([2, 4, 6, 8].my_map {|num| num * 2}).to eql [4, 8, 12, 16]
  end
  
  it "handles an empty array" do
    expect([].my_map {|num| num * 2}).to eql []
  end
end

describe "my_inject" do
  it "gives the product of all numbers in array" do
    expect([2,4,6,2].my_inject(1) {|prod, i| prod * i}).to eql 96
  end
end

describe "my_inject" do
  it "gives the product of all numbers in array" do
    expect([2,4,6,2].my_inject(0) {|sum, i| sum + i}).to eql 14
  end
end
