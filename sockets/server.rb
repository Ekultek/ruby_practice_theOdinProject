# Simple server

require 'socket'
require 'json'

server = TCPServer.open(2000)

def generate_status(status_code, english_reason)
  "HTTP/1.0 #{status_code} #{english_reason}\r\n"
end

def parse_input(body)
  params = JSON.parse(body)
  form = "<li>Name: #{params["viking"]["name"]}</li><li>Email: #{params["viking"]["email"]}</li>"
end

def fill_form(file, body)
  form = parse_input(body)
  file.gsub!("<%= yield %>", form)
end

def generate_response(status, file)
  status + "Date: #{Time.now.ctime}\r\n" + "Content-Length: #{file.to_s.size}\r\n\r\n" + "#{file}\r\n"
end

loop do
  client = server.accept
  request = client.read_nonblock(256).split("\r\n\r\n", 2)
  method = request[0].split(' ')[0]
  path = request[0].split(' ')[1]
  body = request[1]
  
  if method == 'GET'
    if File.exists? path
      status = generate_status(200, 'OK')
      file = File.read (path)
      file_size = file.to_s.size
      response = generate_response(status, file)
    else
      response = generate_status(404, 'Not Found') + "\r\n\""
    end
  elsif method == 'POST'
    if File.exists? path
      status = generate_status(200, 'OK')
      file = File.read(path)
      fill_form(file, body)
      response = generate_response(status, file)
    else
      response = generate_status(404, 'Not Found') + "\r\n\""
    end
   
  end
  client.puts response
  client.close
end

