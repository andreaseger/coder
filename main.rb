require 'rubygems'
require 'sinatra'
require "sinatra/reloader" if development?

require 'fastercsv'

configure do
	Coder = {:tempfile => "tmp/codes.csv"}
end


get '/' do
  erb :form
end

post '/' do
  codes = generate params[:start].to_i, params[:offsets].scan(/\w+|,|\./).delete_if{|t| t =~ /,|\./}.map{|e| e=e.to_i}, params[:count].to_i
end

def generate(start, offsets, count)
  last = start
  codes = []
  row = []
  row_length = offsets.count
  count.times {|c|
    col = c%row_length
    code = last + offsets[col]
    row.push(code)
    if col == row_length - 1
      codes.push(row)
      row = []
    end
    last = code
  }
  unless row == []
    codes.push(row)
  end
  save_in_csv(codes)
  erb :finished
end

def save_in_csv(codes)
  FasterCSV.open(Coder[:tempfile], "w") do |csv|
    codes.each do |row|
      csv << row
    end
  end
end

get '/download' do
  file = Coder[:tempfile]
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end

enable :inline_templates

__END__

@@ form
<form method="post">
  <p>
    <label for="start">Startwert:</label>
    <input type="text" name="start">
  </p>
  <p>
    <label for="offsets">Offsets:</label>
    <input type="text" name="offsets">
  </p>
  <p>
    <label for="count">Count:</label>
    <input type="text" name="count">
  </p>
  <input name="commit" type="submit" value="Go" />
</form>

@@ finished
Codes generiert
<a href="/download">download</a>
