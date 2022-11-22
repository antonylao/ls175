# code doesn't work in Cloud9; run on computer!
# use param number

require "socket"
require "pry"

def parse_request(request_str)
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

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept 

  request_line = client.gets

  next if !request_line || request_line =~ /favicon/ # prevents some undesirable additional requests
  
  puts request_line
  
  http_method, path, params = parse_request(request_line)
  p "request line is:"
  p request_line
  puts "http_method = #{http_method}"
  puts "path = #{path}"
  puts "params = #{params}"
  puts "---------------------"
  
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

  client.puts "<h1>Counter</h1>"
  
  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"

  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"

  client.puts "</body>"
  client.puts "</html>"

  client.close
end