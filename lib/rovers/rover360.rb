require_relative '../grid'
require_relative 'straight_line_rover'
require_relative '../compass_direction'

class Rover360 < StraightLineRover
    attr_accessor :x, :y, :direction, :name, :type

    ROVER_360 = "360"
    NESW = [
        StraightLineRover::NORTH, 
        StraightLineRover::EAST, 
        StraightLineRover::SOUTH, 
        StraightLineRover::WEST
    ]

    def initialize(name)
        super(name)
        @type = ROVER_360
    end

    def start(x, y, direction, grid)
        @x = x
        @y = y
        @direction = direction
        @direction_object = CompassDirection.new(@direction)
        detect_obstacle(x, y, grid)
    end

    def turn(turn)
        current_direction_index = NESW.find_index(@direction)
        new_index = 0
        if turn == StraightLineRover::LEFT
            new_index = shift_nesw_index_left(current_direction_index)
        else
            new_index = shift_nesw_index_right(current_direction_index)
        end
        @direction = NESW[new_index]
    end

    def go_east
        # to do: implement
    end

    def go_west
        # to do: implement
    end

    def get_direction_object
        @direction_object
    end

    private

    def shift_nesw_index_left(index)
        ((index + 4) - 1) % 4
    end

    def shift_nesw_index_right(index)
        (index + 1) % 4
    end
end