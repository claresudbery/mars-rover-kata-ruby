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
        instructions = params["instructions"]
        process_instructions(instructions)

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
            session[:mars_rovers] = Hash.new
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

    def process_instructions(instructions)
        if is_movement?(instructions)
            move_rover(instructions)
        else
            start_rover(convert_first_input(instructions))
        end
    end

    def start_rover(new_rover)
        rover = MarsRoverFactory.new.generate_rover(new_rover[:name], new_rover[:type])
        rover.start(new_rover[:x], new_rover[:y], new_rover[:direction], session[:grid])  
        session[:mars_rovers][new_rover[:name]] = rover      
        session[:grid].update(rover)
        update_display
    end

    def move_rover(instructions)  
        instructions = instructions.split(",")
        rover_name = instructions[0]
        instructions.shift # removes first element
        instructions.each do |movement|   
            process_movement(movement, rover_name)
        end
    end

    def process_movement(movement, rover_name)    
        if is_turn?(movement)       
            session[:mars_rovers][rover_name].turn(movement)
        else
            session[:mars_rovers][rover_name].move(movement, session[:grid])
        end
        session[:grid].update(session[:mars_rovers][rover_name])
        update_display
    end

    def is_turn?(movement)
        MarsRoverApp::TURNS.include?(movement)
    end

    def is_movement?(movement)
        MarsRoverApp::MOVEMENTS.include?(movement[movement.length-1])
    end

    def update_display
        @output = WideScreenPresenter.new.get_display(session[:grid]) + "\n"
        @output = @output + MarsRoverApp::USER_INFORMATION
        @output = "#{@output}\n\n#{MarsRoverApp::REQUEST_FOR_FURTHER_INPUT}\n\n"
    end
end