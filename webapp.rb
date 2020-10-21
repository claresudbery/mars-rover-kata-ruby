require "sinatra/base"
require "erb"

class WebApp < Sinatra::Base
    enable :sessions

    get '/marsrover' do
        erb :marsrover
    end

    run! if app_file == $0
end