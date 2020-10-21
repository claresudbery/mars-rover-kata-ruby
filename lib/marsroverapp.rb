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
            instructions = @communicator.get_input(AppHelper::REQUEST_FOR_FIRST_INPUT)
            start_rover(instructions, @mars_rovers, @grid, @mars_rover_factory)
            update_display
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

    def move_rover_repeatedly
        instructions = ask_for_further_input
        while !instructions.empty? do
            process_instructions(instructions, @mars_rovers, @grid, @mars_rover_factory)
            instructions = ask_for_further_input
        end
    end

    def ask_for_further_input
        @communicator.show_message(AppHelper::USER_INFORMATION)
        instructions = @communicator.get_input(AppHelper::REQUEST_FOR_FURTHER_INPUT)
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

    def start_rover(instructions, mars_rovers, grid, mars_rover_factory)
        new_rover = AppHelper::convert_first_input(instructions) 
        rover = mars_rover_factory.generate_rover(new_rover[:name], new_rover[:type])
        rover.start(new_rover[:x], new_rover[:y], new_rover[:direction], grid)
        grid.update(rover)
        mars_rovers[new_rover[:name]] = rover
    end

    def update_display
        @presenter.show_display(@grid)
    end

    def process_instructions(instructions, rovers, grid, rover_factory)
        if is_movement?(instructions)
            move_rover(instructions, rovers, grid)
        else
            start_rover(instructions, rovers, grid, rover_factory)
        end
        update_display
    end

    def is_turn?(movement)
        AppHelper::TURNS.include?(movement)
    end

    def is_movement?(movement)
        AppHelper::MOVEMENTS.include?(movement[movement.length-1])
    end
end