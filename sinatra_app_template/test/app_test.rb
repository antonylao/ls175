ENV["RACK_ENV"] = "test" #this ensures that Sinatra does not start a web server

require "minitest/autorun"
require "rack/test" #require the app method in the test class

require_relative "../app"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  # Rack::Test::Methods require a app method that returns an instance of the Rack application
  def app
    Sinatra::Application
  end

  # access the session hash
  def session
    last_request.env["rack.session"]
  end

  def test_index
    get "/"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_equal "Hello, world!", last_response.body
  end
end