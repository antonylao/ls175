require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

def each_chapter
  @contents.each_with_index do |chapter_name, index|
    chapter_no = index + 1
    chapter_contents = File.read("data/chp#{chapter_no}.txt")
    yield(chapter_no, chapter_name, chapter_contents)
  end
end

def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |chapter_no, chapter_name, chapter_contents|
    matches = {}
    chapter_contents.split("\n\n").each_with_index do |paragraph, index|
      paragraph_id = index + 1
      matches[paragraph_id] = paragraph if paragraph.include?(query)
    end
    results << {number: chapter_no, name: chapter_name, paragraphs: matches} unless matches.size == 0
  end

  results
end

before do
  @contents = File.readlines("data/toc.txt", chomp: true)
end

helpers do 
  def in_paragraphs(text)
    text_arr = text.split("\n\n")
    text_arr.map.with_index do |paragraph, index|
      paragraph_id = index + 1
      "<p id=#{paragraph_id}>#{paragraph}</p>"
    end.join
  end

  def highlight(text, matching_text)
    text.gsub(matching_text, "<strong>#{matching_text}</strong>")
  end
end

get "/" do   # declaring a route that matches the URL "/". The return value of the block that follows will be sent by Sinatra to the browser.
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  redirect "/" unless (1..@contents.size).cover?(number)

  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do 
  params[:name]
end

get "/search" do
  @results = chapters_matching(params[:query])

  erb :search
end

not_found do 
  redirect "/"
end
