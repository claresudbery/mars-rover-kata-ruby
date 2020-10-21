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
            error = AppHelper::BAD_INPUT_ERROR
        rescue SkyHighObstacleException => e
            error = AppHelper::SKY_HIGH_OBSTACLE_ERROR
        rescue ObstacleException => e
            error = AppHelper::OBSTACLE_ERROR
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
end