class AppHelper
    USER_INFORMATION_ALL_ROVERS = "There are three types of Rover: Straight-line rover = 'SLR', Rover360 = '360', FlyingRover = 'FLY'"
    USER_INFORMATION = "You may have heard rumours of flying rovers and straight-line rovers, but these are still under construction. For now we only have Rover360s. When creating a new rover, use '360' for type."
    REQUEST_FOR_FIRST_INPUT = "Please input a 3-letter name, type, start coordinates and a direction for your Rover - eg ANN,360,0,0,N"
    REQUEST_FOR_FURTHER_INPUT = "Please input, comma-separated, either rover name followed by a sequence of the following single chars: f(forwards), b(backwards), l(left), r(right) - eg 'ANN,r,f,f' ... or a 3-letter name, start coordinates, type and a direction for a new Rover - eg 'MIN,360,0,0,N'"
    BAD_INPUT_ERROR = "Sorry, I don't understand that input."
    OBSTACLE_ERROR = "Oh no, I'm sorry, I can't process that instruction. There is an obstacle in the way!"
    SKY_HIGH_OBSTACLE_ERROR = "Oh no, I'm sorry, I can't process that instruction. There is a sky-high obstacle in the way!"
    MOVEMENTS = [StraightLineRover::LEFT, StraightLineRover::RIGHT, StraightLineRover::FORWARD, StraightLineRover::BACKWARD]
    TURNS = [StraightLineRover::LEFT, StraightLineRover::RIGHT]

    def self.handle_mars_rover_exceptions 
        error = ""

        begin
            yield
        rescue BadInputException => e            
            error = BAD_INPUT_ERROR
        rescue SkyHighObstacleException => e
            error = SKY_HIGH_OBSTACLE_ERROR
        rescue ObstacleException => e
            error = e.message
        rescue StandardError => e
            error = e.message
        end

        error
    end

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