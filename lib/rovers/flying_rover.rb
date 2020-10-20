class FlyingRover < Rover360
    FLYING = "FLY"

    def initialize(name)
        super(name)
        @type = FLYING
    end

    def detect_obstacle(x, y, grid)
        if grid.contains_sky_high_obstacle?(x, y)
            raise SkyHighObstacleException.new
        end
    end
end