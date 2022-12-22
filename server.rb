# code doesn't work in Cloud9; run on computer!

require "socket"

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

=begin
  # How to print the whole request

  #prints the request head
  loop do
    line = client.gets
    puts line
    break if line == "\r\n"
  end

  #prints the request head and body
  loop do
    line = client.gets
    request << line  

    content_length = line.split(": ")[1].to_i if line.include?("Content-Length")

    if line == "\r\n"
      body = client.readpartial(content_length) if request.include?("Content-Length")
      break
    end
  end

  puts request
  puts body unless body.empty?
=end

  request_line = client.gets # first line of the request
  puts request_line

  # some browsers (ex: Google Chrome) require a well-formed response to be sent to it for rendering.
  # We must also include a blank line for separating the status line + optional headers, and the message body
  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/plain\r\n\r\n"

  client.puts request_line
  client.close
end