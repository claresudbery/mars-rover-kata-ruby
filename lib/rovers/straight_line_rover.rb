require_relative '../grid'

class StraightLineRover
    attr_accessor :x, :y, :direction, :name, :type,

    NORTH = "N"
    SOUTH = "S"
    FORWARD = "f"
    BACKWARD = "b"
    LEFT = "l"
    RIGHT = "r"
    STRAIGHT_LINE = "SLR"
    EAST = "E"
    WEST = "W"

    MOVEMENTS = {
        NORTH => {x: 0, y: -1},
        EAST => {x: 1, y: 0},
        SOUTH => {x: 0, y: 1},
        WEST => {x: -1, y: 0},
    }

    def initialize(name)
        @name = name
        @type = STRAIGHT_LINE
    end

    def start(x, y, direction, grid)
        @x = x
        @y = y
        @direction = direction
        @direction_object = StraightLineDirection.new(@direction)
        # throw error if direction is east or west
        # this error will need to be caught and handled higher up the call chain
        detect_obstacle(@x, @y, grid)
    end

    def move(movement, grid)
        new_x = wrap_if_necessary(@x + get_coord_diff(:x, movement), grid.width)
        new_y = wrap_if_necessary(@y + get_coord_diff(:y, movement), grid.height)

        if grid.contains_obstacle?(new_x, new_y)
            raise ObstacleException.new
        else
            @x = new_x
            @y = new_y
        end
    end

    def turn(turn)
        # The current assumption is that turn is a string containing either LEFT or RIGHT.
        # Add the ability to turn in any direction from any direction
        # In this class you turn 180 degrees for each turn
    end

    def detect_obstacle(x, y, grid)
        if grid.contains_obstacle?(x, y)
            raise ObstacleException.new
        end
    end

    def go_north
        # to do: implement
    end

    def go_south
        # to do: implement
    end

    def get_direction_object
        @direction_object
    end

    private 

    def wrap_if_necessary(coord, limit)
        (coord + limit) % limit
    end

    def get_coord_diff(coord_symbol, movement)
        MOVEMENTS[@direction][coord_symbol] * movement_multiplier(movement)
    end
    
    def movement_multiplier(movement)
        movement == FORWARD ? 1 : -1
    end
end