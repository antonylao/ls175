require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

require "yaml"
require 'pry'

helpers do
  def count_users
    @users.size
  end
  
  def count_interests
    counter = 0
    @users.each do |_, user_infos|
      counter += user_infos[:interests].size
    end
    
    counter
  end
  
  def list_usernames
    @users.keys
  end
  
  def other_users(username)
    users_arr = list_usernames
    users_arr.delete(username.to_sym)
  
    users_arr
  end
end

before do 
  # instance variables used in all pages go here
  @users = YAML.load_file("users.yaml")
end

get "/" do
  erb :home, layout: :layout
end

get "/:user_name" do
  @user_name = params[:user_name].to_sym

  redirect "/" unless list_usernames.include?(@user_name)
  
  @email = @users[@user_name][:email]
  @interests = @users[@user_name][:interests]
  
  erb :user_page
end