require_relative 'exceptions/obstacle_error'
require_relative 'exceptions/bad_input_error'
require_relative 'exceptions/sky_high_obstacle_error'

class AppHelper
    USER_INFORMATION_ALL_ROVERS = "There are three types of Rover: Straight-line rover = 'SLR', Rover360 = '360', FlyingRover = 'FLY'"
    USER_INFORMATION = "You may have heard rumours of flying rovers and straight-line rovers, but these are still under construction. \nFor now we only have Rover360s. When creating a new rover, use '360' for type."
    REQUEST_FOR_FIRST_INPUT = "Please input a 3-letter name, type, start coordinates and a direction for your Rover - eg ANN,360,0,0,N"
    REQUEST_FOR_FURTHER_INPUT = "Please input, comma-separated, one of the following: \n\nTo create a new rover: 3-letter name, start coordinates, type and a direction for a new Rover - eg 'MIN,360,0,0,N' \nTo direct a rover: Rover name followed by a sequence of the following single chars: f(forwards), b(backwards), l(left), r(right) - eg 'ANN,r,f,f' \nNB: You can't direct a rover until you create it."
    MOVEMENTS = [StraightLineRover::LEFT, StraightLineRover::RIGHT, StraightLineRover::FORWARD, StraightLineRover::BACKWARD]
    TURNS = [StraightLineRover::LEFT, StraightLineRover::RIGHT]

    def self.convert_first_input(new_rover)
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

    def self.start_rover(instructions, mars_rovers, grid, mars_rover_factory)
        new_rover = convert_first_input(instructions) 
        rover = mars_rover_factory.generate_rover(new_rover[:name], new_rover[:type])
        rover.start(new_rover[:x], new_rover[:y], new_rover[:direction], grid)
        grid.update(rover)
        mars_rovers[new_rover[:name]] = rover
    end

    def self.move_rover(instructions, rovers, grid)  
        instructions = instructions.split(",")
        rover_name = instructions[0]
        instructions.shift # removes first element
        instructions.each do |movement|   
            process_movement(movement, rovers[rover_name], grid)
        end
    end

    def self.process_movement(movement, rover, grid)    
        if is_turn?(movement)       
            rover.turn(movement)
        else
            rover.move(movement, grid)
        end
        grid.update(rover)
    end

    def self.process_instructions(instructions, rovers, grid, rover_factory)
        if is_movement?(instructions)
            move_rover(instructions, rovers, grid)
        else
            start_rover(instructions, rovers, grid, rover_factory)
        end
    end

    def self.is_turn?(movement)
        TURNS.include?(movement)
    end

    def self.is_movement?(movement)
        MOVEMENTS.include?(movement[movement.length-1])
    end
end