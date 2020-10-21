require "sinatra/base"
require "erb"

require_relative 'lib/presenters/wide_screen_presenter'
require_relative 'lib/grid'
require_relative 'lib/marsroverapp'
require_relative 'lib/rovers/mars_rover_factory'

class WebApp < Sinatra::Base
    enable :sessions

    get '/marsrover' do
        update_grid
        update_display

        erb :marsrover
    end    

    post '/marsrover' do
        update_grid
        new_rover = convert_first_input(params["instructions"])
        start_rover(new_rover)

        erb :marsrover
    end

    run! if app_file == $0

    private

    def create_grid
        grid = Grid.new(5, 5)
        grid.add_obstacle(3,2)
        grid.add_sky_high_obstacle(2,3)
        grid
    end

    def update_grid
        if session[:grid] == nil            
            session[:grid] = create_grid
        end
    end

    def convert_first_input(new_rover)
        new_rover = new_rover.split(',')
        new_rover = {
            name: new_rover[0],
            type: new_rover[1],           
            x: new_rover[2].to_i,
            y: new_rover[3].to_i,
            direction: new_rover[4]
        }
        new_rover
    end

    def start_rover(new_rover)
        rover = MarsRoverFactory.new.generate_rover(new_rover[:name], new_rover[:type])
        rover.start(new_rover[:x], new_rover[:y], new_rover[:direction], session[:grid])        
        session[:grid].update(rover)
        update_display
    end

    def update_display
        @output = WideScreenPresenter.new.get_display(session[:grid]) + "\n"
        @output = @output + MarsRoverApp::USER_INFORMATION
        @output = "#{@output}\n\n#{MarsRoverApp::REQUEST_FOR_FURTHER_INPUT}\n\n"
    end
end