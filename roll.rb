# code doesn't work in Cloud9; run on computer!
# use params rolls, sides

require "socket"
require "pry"

def parse_request(request_str)
  return [nil, nil, {}] if (request_str == nil || request_str.strip == "")

  http_method, path_and_params, http = request_str.split(" ")
  path, params_str = split_path_and_query_string(path_and_params)
  params = split_query_params(params_str)

  [http_method, path, params]
end

def split_query_params(query_string_str)
  #LS solution
  # query_string_str.split("&").each_with_object({}) do |pair, hash|
  #   key, value = pair.split(query_string_str)
  #   hash[key] = value
  # end

  # My solution
  return {} if (query_string_str == nil || query_string_str == "")

  params_hash = {}

  query_string_str.split("&").each do |param_and_value|
    next if param_and_value.split("=").length != 2
    param, value = param_and_value.split("=")
    params_hash[param] = value
  end 

  params_hash
end

def split_path_and_query_string(str)
  str.split("?")
end

def rolls(client, query_params)
  if rolls_params_valid?(query_params)
    rolls_int = query_params["rolls"].to_i
    sides_int = query_params["sides"].to_i

    rolls_int.times do 
      roll = rand(sides_int) + 1
      client.puts "<p>", roll, "</p>"
    end
  end
end

def rolls_params_valid?(params_hash)
  return false if params_hash == nil

  return false if params_hash["rolls"] == nil || params_hash["rolls"] == ""
  return false if params_hash["sides"] == nil || params_hash["sides"] == ""

  return false if (params_hash["rolls"].to_i <= 0) || (params_hash["sides"].to_i <= 0)

  true
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept # "asks the server to start listening on the specified port 3003 and accept incoming requests. The object it returns (a TCPSocket object) has methods that give you access to the data (text) received in a particular request. We assign it to a client variable here. We don't have to."

  request_line = client.gets # returns first line of the client request
  # "gets has absolutely nothing to do with HTTP. In fact, our server isn't HTTP aware, it's simply a TCP server that gives you access to the text-based data it receives over the network line-by-line. That text may or may not be formatted in HTTP. gets is like the gets method you use to get input from the command-line, except that the input is the data received from a network request."

  # next if !request_line || request_line =~ /favicon/ # prevents some undesirable additional requests
  
  puts request_line

  http_method, path, params = parse_request(request_line)

  # some browsers (ex: Google Chrome) require a well-formed response to be sent to it for rendering.
  # We must also include a blank line for separating the status line + optional headers, and the message body
  # client.puts "HTTP/1.1 200 OK"
  # client.puts "Content-Type: text/plain\r\n\r\n"

  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  # for development 
  client.puts "http_method = #{http_method}"
  client.puts "path = #{path}"
  client.puts "params = #{params}"
  client.puts "---------------------"
  client.puts "</pre>"

  # client.puts request_line

  client.puts "<h1>Rolls!</h1>"

  rolls(client, params)
  client.puts "</body>"
  client.puts "</html>"

  client.close
end
