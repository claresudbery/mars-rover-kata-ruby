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
            process_instructions(instructions, session[:mars_rovers], session[:grid], MarsRoverFactory.new) do
                update_display
            end
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

    def start_rover(instructions, mars_rovers, grid, mars_rover_factory)
        new_rover = AppHelper::convert_first_input(instructions) 
        rover = mars_rover_factory.generate_rover(new_rover[:name], new_rover[:type])
        rover.start(new_rover[:x], new_rover[:y], new_rover[:direction], grid)
        grid.update(rover)
        mars_rovers[new_rover[:name]] = rover
    end

    def move_rover(instructions, rovers, grid)  
        instructions = instructions.split(",")
        rover_name = instructions[0]
        instructions.shift # removes first element
        instructions.each do |movement|   
            process_movement(movement, rovers[rover_name], grid)
        end
    end

    def process_movement(movement, rover, grid)    
        if is_turn?(movement)       
            rover.turn(movement)
        else
            rover.move(movement, grid)
        end
        grid.update(rover)
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

    def process_instructions(instructions, rovers, grid, rover_factory)
        if is_movement?(instructions)
            move_rover(instructions, rovers, grid)
        else
            start_rover(instructions, rovers, grid, rover_factory)
        end
        yield
    end

    def is_turn?(movement)
        AppHelper::TURNS.include?(movement)
    end

    def is_movement?(movement)
        AppHelper::MOVEMENTS.include?(movement[movement.length-1])
    end
end