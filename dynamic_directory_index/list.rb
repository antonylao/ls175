require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do 
  @files = Dir.glob("public/*").map do |path|
    File.basename(path)
  end.sort

  if params['sort'] == 'desc'
    @files.reverse!
  end
  
  erb :list
end
