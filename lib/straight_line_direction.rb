class StraightLineDirection
    def initialize(direction)
        @direction = direction
    end

    def is_north?
        @direction == StraightLineRover::NORTH
    end

    def is_south?
        @direction == StraightLineRover::SOUTH
    end
end