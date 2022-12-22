# monroe.rb
# (framework)

class Monroe
  def erb(filename, local = {})
    b = binding # binding of the method
    message = local[:message]
    template = File.read("views/#{filename}.erb")
    content = ERB.new(template)
    content.result(b) # binding of the method is made available to the view templates
  end

  def response(status, headers, body = '')
    body = yield if block_given?
    [status, headers, [body]]
  end
end