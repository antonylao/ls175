require "sinatra"
require "sinatra/reloader" if development? # reload the application at each request (except in production)
require "sinatra/content_for" # to display content to a layout from a view template: uses content_for and yield_content methods in erb files
require "tilt/erubis" # to use erb files

require 'sysrandom/securerandom' # used to generate secure random session secret

configure do
  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
end


helpers do
end

# def helper_methods (!= view helpers) here

before do
end

after do
end

get "/" do
  "Hello, world!"
end