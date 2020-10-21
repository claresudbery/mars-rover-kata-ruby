require_relative 'exceptions/bad_input_exception'
require_relative 'exceptions/obstacle_exception'
require_relative 'exceptions/sky_high_obstacle_exception'
require_relative 'app_helper'

class MarsRoverApp
    def initialize(presenter, communicator, grid, mars_rover_factory)
        @presenter = presenter
        @communicator = communicator
        @grid = grid
        @mars_rover_factory = mars_rover_factory
        @mars_rovers = Hash.new
    end

    def start
        handle_exceptions do
            @presenter.show_display(@grid)
            @communicator.show_message(AppHelper::USER_INFORMATION)
            new_rover = convert_first_input(@communicator.get_input(AppHelper::REQUEST_FOR_FIRST_INPUT))
            start_rover(new_rover)
            move_rover_repeatedly
        end
    end

    private

    def handle_exceptions 
        error = AppHelper.handle_mars_rover_exceptions do
            yield
        end

        if !error.empty?
            puts error
            move_rover_repeatedly
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

    def move_rover_repeatedly
        instructions = ask_for_further_input
        while !instructions.empty? do
            process_instructions(instructions)
            instructions = ask_for_further_input
        end
    end

    def ask_for_further_input
        @communicator.show_message(AppHelper::USER_INFORMATION)
        instructions = @communicator.get_input(AppHelper::REQUEST_FOR_FURTHER_INPUT)
    end

    def process_instructions(instructions)
        if is_movement?(instructions)
            move_rover(instructions)
        else
            start_rover(convert_first_input(instructions))
        end
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
            @mars_rovers[rover_name].turn(movement)
        else
            @mars_rovers[rover_name].move(movement, @grid)
        end
        update_display(@mars_rovers[rover_name])
    end

    def is_turn?(movement)
        AppHelper::TURNS.include?(movement)
    end

    def is_movement?(movement)
        AppHelper::MOVEMENTS.include?(movement[movement.length-1])
    end

    def start_rover(new_rover)
        rover = @mars_rover_factory.generate_rover(new_rover[:name], new_rover[:type])
        rover.start(new_rover[:x], new_rover[:y], new_rover[:direction], @grid)
        update_display(rover)
        @mars_rovers[new_rover[:name]] = rover
    end

    def update_display(rover)
        @grid.update(rover)
        @presenter.show_display(@grid)
    end
end