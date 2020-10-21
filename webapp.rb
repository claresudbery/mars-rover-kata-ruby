require "sinatra/base"
require "erb"

require_relative 'lib/presenters/wide_screen_presenter'
require_relative 'lib/grid'
require_relative 'lib/marsroverapp'
require_relative 'lib/rovers/mars_rover_factory'

class WebApp < Sinatra::Base
    enable :sessions

    get '/marsrover' do
        mars_rover_factory = MarsRoverFactory.new
        grid = Grid.new(5, 5)
        grid.add_obstacle(3,2)
        grid.add_sky_high_obstacle(2,3)
        presenter = WideScreenPresenter.new

        @output = presenter.get_display(grid) + "\n"
        @output = @output + MarsRoverApp::USER_INFORMATION + "\n" + "\n"
        @output = @output + MarsRoverApp::REQUEST_FOR_FIRST_INPUT + "\n" + "\n"

        erb :marsrover
    end

    run! if app_file == $0
end