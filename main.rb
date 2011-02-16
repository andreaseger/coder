require 'rubygems'
require 'sinatra'
require "sinatra/reloader" if development?

get '/' do
  erb :form
end

post '/' do |start, offset, count|
  "#{start} #{offset} #{count}"
end

enable :inline_templates

__END__

@@ form
<form action="" method="post">
  <p>
    <label for="start">Startwert:</label>
    <input type="text" name="start">
  </p>
  <p>
    <label for="offset">Offset:</label>
    <input type="text" name="start">
  </p>
  <p>
    <label for="count">Count:</label>
    <input type="text" name="count">
  </p>
  <input name="commit" type="submit" value="Go" />
</form>


