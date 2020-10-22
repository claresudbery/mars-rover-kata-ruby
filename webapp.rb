require "sinatra/base"
require "erb"

require_relative 'lib/presenters/wide_screen_presenter'
require_relative 'lib/grid'
require_relative 'lib/marsroverapp'
require_relative 'lib/rovers/mars_rover_factory'
require_relative 'lib/app_helper.rb'

class WebApp < Sinatra::Base
    enable :sessions

    get '/marsrover' do
        handle_exceptions do
            update_grid
            update_display
        end

        erb :marsrover
    end    

    post '/marsrover' do
        handle_exceptions do
            update_grid
            instructions = params["instructions"]
            AppHelper::process_instructions(instructions, session[:mars_rovers], session[:grid], MarsRoverFactory.new)
            update_display
        end

        erb :marsrover
    end

    run! if app_file == $0

    private

    def handle_exceptions 
        error = AppHelper.handle_mars_rover_exceptions do
            yield
        end

        if !error.empty?
            show_error(error)
        end
    end

    def create_grid
        grid = Grid.new(5, 5)
        grid.add_obstacle(3,2)
        grid.add_sky_high_obstacle(2,3)
        grid
    end

    def update_grid
        if session[:grid] == nil            
            session[:grid] = create_grid
            session[:mars_rovers] = Hash.new
        end
    end

    def show_error(error)
        @output = update_display + error + "\n\n"
    end

    def update_display
        @output = WideScreenPresenter.new.get_display(session[:grid]) + "\n"
        @output = @output + AppHelper::USER_INFORMATION + "\n\n"
        @output = @output + AppHelper::REQUEST_FOR_FURTHER_INPUT + "\n\n"
        @output
    end
end