require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

puts "EventManager Initialized!"

def clean_zipcode(zipcode)
    zipcode.to_s.slice(0..4).rjust(5, '0')
end

def legislators_by_zipcode(zipcode)
   Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir('output') unless Dir.exists? 'output'
  
  filename = "output/thanks_#{id}.html"
  
  File.open(filename, 'w') do |file|
    file.puts form_letter
 end
end

def phone_format(telephone)
    telephone.insert 3, '-'
    telephone.insert 7, '-'
end

def clean_telephone(telephone)
  telephone.gsub!(/[^A-Za-z0-9]/i, '')
  if telephone.length < 10 or telephone.length > 11
    telephone = '000-000-0000'
  elsif telephone.length == 11
    if telephone[0] == '1'
      telephone = phone_format(telephone[1..-1])
    else
      telephone = '000-000-0000'
      end
  else
    phone_format(telephone)
  end
end

def time_to_hour(time)
   DateTime.strptime(time, '%m/%d/%Y %H:%M').hour
end


def largest_hash_key(dictionary)
  max = dictionary.values.max
  Hash[dictionary.select {|key, value| value == max}]
end

def time_to_wday(time)
  DateTime.strptime(time, '%m/%d/%Y %H:%M').wday
end


template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

  
contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol
popular_hours = []
popular_days = []
contents.each do |row| 
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode]) 
  telephone = clean_telephone(row[:homephone])
  time_registered = time_to_hour(row[:regdate])
  day_registered = time_to_wday(row[:regdate])
  popular_hours << time_registered
  popular_days << day_registered
  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)
  
  save_thank_you_letters(id, form_letter)
  puts "#{name} #{zipcode} #{telephone} "
end


hour_dict = Hash.new(0)
popular_hours.each do |hour|
  hour_dict[hour] += 1
end

wday_dict = Hash.new(0)
popular_days.each do |day|
  wday_dict[day] += 1
end

wday_map = {0=> 'Sunday', 1=> 'Monday', 2=> 'Tuesday', 3=> 'Wednesday', 4=> 'Thursday', 5=> 'Friday', 6=> 'Saturday', 7=> 'Sunday'}

puts "Most popular hour(s) to register is: #{largest_hash_key(hour_dict).keys.join(':00, ')}:00."
puts "Most popular day to register is: #{wday_map[largest_hash_key(wday_dict).keys.join('').to_i]}."




