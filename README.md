Files in the main repo (server, template, roll, counter.rb) serve as a basis to make a client-server connection

My_framework/ makes use of the Rack gem as an application server (translates HTTP request into value-pairs, need a call(env) method defined in the main app)
  - config.ru is used by Rack and runs the class with the call(env) method defined
  - Main app: app.rb
  - Framework: monroe.rb (Monroe is a superclass of App)
  - Side files: advice.rb
  - View templates are used to provide separation between HTML code and application code
  - NB: here we use the WEBrick web server, instead of our own TCP server. Rack helps us to connect easily to WEBrick.

book_viewer/ downloaded from https://da77jsbdz4r05.cloudfront.net/templates/book_viewer_r20160624.zip
  - enter `bundle exec ruby book_viewer` to start server
  - type as URL `localhost:4567/` (see views/home.erb) or `localhost:4567/chapters/1` (see views/chapter.erb)
  
dynamic_directory_index/ code challenge from LS
  - display the files from a subfolder
  - the files in the public/ directory can be accessed by using the filename as a path (`localhost:4567/1.jpg`)

users_and_interests/ code challenge from LS
  - display the list of users and their info (interests, email) based on a YAML file

sinatra_todos/ (lesson 4)
downloaded from https://da77jsbdz4r05.cloudfront.net/templates/sinatra_todos_r20160624.zip
(completed project: https://ls-170-sinatra-todos.herokuapp.com/lists)
(completed code: https://da77jsbdz4r05.cloudfront.net/templates/sinatra_todos_final_r20160624.zip)
  - after a form with the "GET" method is sent, you can retrieve it in Sinatra with the `params[:name_of_input]`
  - to run with Heroku, the root of the project must be in a separate Github root directory