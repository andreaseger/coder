require 'main'
set :run, false
set :environment, :production
run Sinatra::Application
