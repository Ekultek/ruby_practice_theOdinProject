# Web Browser 

require 'socket'
require 'json'
host = 'localhost'
port = 2000

def request_method(action, file)
  return "#{action} #{file} HTTP/1.0\r\n\""
end

def input_name
  print "Enter full name: "
  gets.chomp
end

def input_email
  print "Enter email: "
  email = gets.chomp
end

def viking_hash(name, email)
   {:viking => {:name => name, :email => email}}
end

print "Would you like to (G)ET or (P)OST? : "
action = gets.chomp.upcase

if action == 'G'
  path = 'index.html'
  request = request_method('GET', path) + "\r\n"

elsif action == 'P'
  path = 'thanks.html'
  status = request_method('POST', path) 
  puts "Complete Viking Raid Registration: "
  name = input_name
  email = input_email  
  form_data = viking_hash(name, email)
  form_size = form_data.to_s.size
  request = status + "Content-Length: #{form_size}\r\n\r\n" + "#{form_data.to_json}"
else
  puts "Invalid request"
end

socket = TCPSocket.open(host, port)
socket.print(request)
response = socket.read
print response
